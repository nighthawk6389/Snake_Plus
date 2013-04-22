library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.definitions.all;

entity de2_wm8731_audio is
port (
    clk : in std_logic;       --  Audio CODEC Chip Clock AUD_XCK (18.43 MHz)
    reset_n : in std_logic;
    test_mode : in std_logic;       --    Audio CODEC controller test mode
    audio_request : out std_logic;  --    Audio controller request new data
    data : in unsigned(15 downto 0);
  
    -- Audio interface signals
    AUD_ADCLRCK  : out  std_logic;   --    Audio CODEC ADC LR Clock
    AUD_ADCDAT   : in   std_logic;   --    Audio CODEC ADC Data
    AUD_DACLRCK  : out  std_logic;   --    Audio CODEC DAC LR Clock
    AUD_DACDAT   : out  std_logic;   --    Audio CODEC DAC Data
    AUD_BCLK     : inout std_logic  --    Audio CODEC Bit-Stream Clock
  );
end  de2_wm8731_audio;

architecture rtl of de2_wm8731_audio is     

    signal lrck : std_logic;
    signal bclk : std_logic;
    signal xck  : std_logic;
    
    signal lrck_divider : unsigned(7 downto 0); 
    signal bclk_divider : unsigned(3 downto 0);
    
    signal set_bclk : std_logic;
    signal set_lrck : std_logic;
    signal clr_bclk : std_logic;
    signal lrck_lat : std_logic;
    
    signal shift_out : unsigned(15 downto 0);

    signal sin_out     : unsigned(15 downto 0);
    signal sin_counter : unsigned(5 downto 0); 

	 signal select_sound : integer;
	 signal sound_out : unsigned(15 downto 0);

	 type sound_ram is array(0 to 15) of unsigned(15 downto 0);
	 
	 constant sound1 : sound_ram := (
		X"0000", X"10b4", X"2120",
		X"30fb", X"3fff", X"4deb",
		X"5a81", X"658b", X"6ed9",
		X"7640", X"7ba2", X"7ee6",
		X"7fff", X"7ee6", X"7ba2",
		X"7640"
	);
	
begin
  
    -- LRCK divider 
    -- Audio chip main clock is 18.432MHz / Sample rate 48KHz
    -- Divider is 18.432 MHz / 48KHz = 192 (X"C0")
    -- Left justify mode set by I2C controller
    
  process (clk)
  begin
    if rising_edge(clk) then
      if reset_n = '0' then 
        lrck_divider <= (others => '0');
      elsif lrck_divider = X"BF"  then        -- "C0" minus 1
        lrck_divider <= X"00";
      else 
        lrck_divider <= lrck_divider + 1;
      end if;
    end if;   
  end process;

  process (clk)
  begin
    if rising_edge(clk) then      
      if reset_n = '0' then 
        bclk_divider <= (others => '0');
      elsif bclk_divider = X"B" or set_lrck = '1'  then  
        bclk_divider <= X"0";
      else 
        bclk_divider <= bclk_divider + 1;
      end if;
    end if;
  end process;

  set_lrck <= '1' when lrck_divider = X"BF" else '0';
    
  process (clk)
  begin
    if rising_edge(clk) then
      if reset_n = '0' then
        lrck <= '0';
      elsif set_lrck = '1' then 
        lrck <= not lrck;
      end if;
    end if;
  end process;
    
  -- BCLK divider
  set_bclk <= '1' when bclk_divider(3 downto 0) = "0101" else '0';
  clr_bclk <= '1' when bclk_divider(3 downto 0) = "1011" else '0';
  
  process (clk)
  begin
    if rising_edge(clk) then
      if reset_n = '0' then
        bclk <= '0';
      elsif set_lrck = '1' or clr_bclk = '1' then
        bclk <= '0';
      elsif set_bclk = '1' then 
        bclk <= '1';
      end if;
    end if;
  end process;

  -- Audio data shift output
  process (clk)
  begin
    if rising_edge(clk) then
      if reset_n = '0' then
        shift_out <= (others => '0');
      elsif set_lrck = '1' then
        if test_mode = '1' then 
          shift_out <= sin_out;
        else 
				if data = "0000000000000001" then
					select_sound <= 1;
					shift_out <= sound_out;
				end if;
        end if;
      elsif clr_bclk = '1' then 
        shift_out <= shift_out (14 downto 0) & '0';
      end if;
    end if;   
  end process;

    -- Audio outputs
    
    AUD_ADCLRCK  <= lrck;          
    AUD_DACLRCK  <= lrck;          
    AUD_DACDAT   <= shift_out(15); 
    AUD_BCLK     <= bclk;          

    -- Self test with Sin wave
    
    process(clk)      
    begin
      if rising_edge(clk) then
        if reset_n = '0' then 
            sin_counter <= (others => '0');
        elsif lrck_lat = '1' and lrck = '0'  then  
          if sin_counter = "101111" then 
            sin_counter <= "000000";
          else  
            sin_counter <= sin_counter + 1;
          end if;
        end if;
      end if;
    end process;

    process(clk)
    begin
      if rising_edge(clk) then
        lrck_lat <= lrck;
      end if;
    end process;

    process (clk) 
    begin
      if rising_edge(clk) then 
        if lrck_lat = '1' and lrck = '0' then
          audio_request <= '1';
        else 
          audio_request <= '0';
        end if;
      end if;
    end process;
	 
	 with select_sound select sound_out <=
		sound1(to_integer(sin_counter)) when 1,
		X"0000" when others; 
		
	

  with sin_counter select sin_out <=
    X"0000" when "000000",
    X"10b4" when "000001",
    X"2120" when "000010",
    X"30fb" when "000011",
    X"3fff" when "000100",
    X"4deb" when "000101",
    X"5a81" when "000110",
    X"658b" when "000111",
    X"6ed9" when "001000",
    X"7640" when "001001",
    X"7ba2" when "001010",
    X"7ee6" when "001011",
    X"7fff" when "001100",
    X"7ee6" when "001101",
    X"7ba2" when "001110",
    X"7640" when "001111",
    X"6ed9" when "010000",
    X"658b" when "010001",
    X"5a81" when "010010",
    X"4deb" when "010011",
    X"3fff" when "010100",
    X"30fb" when "010101",
    X"2120" when "010110",
    X"10b4" when "010111",
    X"0000" when "011000",
    X"ef4b" when "011001",
    X"dee0" when "011010",
    X"cf05" when "011011",
    X"c001" when "011100",
    X"b215" when "011101",
    X"a57e" when "011110",
    X"9a74" when "011111",
    X"9127" when "100000",
    X"89bf" when "100001",
    X"845d" when "100010",
    X"8119" when "100011",
    X"8000" when "100100",
    X"8119" when "100101",
    X"845d" when "100110",
    X"89bf" when "100111",
    X"9127" when "101000",
    X"9a74" when "101001",
    X"a57e" when "101010",
    X"b215" when "101011",
    X"c000" when "101100",
    X"cf05" when "101101",
    X"dee0" when "101110",
    X"ef4b" when "101111",
    X"0000" when others;      

end architecture;


