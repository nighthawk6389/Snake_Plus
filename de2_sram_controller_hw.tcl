# TCL File Generated by Component Editor 12.1
# Tue Apr 02 15:22:20 EDT 2013
# DO NOT MODIFY


# 
# de2_sram_controller "de2_sram_controller" v1.0
# null 2013.04.02.15:22:20
# 
# 

# 
# request TCL package from ACDS 11.0
# 
package require -exact sopc 11.0


# 
# module de2_sram_controller
# 
set_module_property NAME de2_sram_controller
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME de2_sram_controller
set_module_property TOP_LEVEL_HDL_FILE de2_sram_controller.vhd
set_module_property TOP_LEVEL_HDL_MODULE de2_sram_controller
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property STATIC_TOP_LEVEL_MODULE_NAME de2_sram_controller
set_module_property FIX_110_VIP_PATH false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# files
# 
add_file de2_sram_controller.vhd {SYNTHESIS SIMULATION}


# 
# file sets
# 

# 
# parameters
# 


# 
# display items
# 


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressAlignment DYNAMIC
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock ""
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 isMemoryDevice true
set_interface_property avalon_slave_0 isNonVolatileStorage false
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 printableDevice false
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true

add_interface_port avalon_slave_0 chipselect chipselect Input 1
add_interface_port avalon_slave_0 write write Input 1
add_interface_port avalon_slave_0 read read Input 1
add_interface_port avalon_slave_0 address address Input 18
add_interface_port avalon_slave_0 readdata readdata Output 16
add_interface_port avalon_slave_0 writedata writedata Input 16
add_interface_port avalon_slave_0 byteenable byteenable Input 2
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 1
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock ""
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true

add_interface_port conduit_end SRAM_DQ export Bidir 16
add_interface_port conduit_end SRAM_ADDR export Output 18
add_interface_port conduit_end SRAM_UB_N export Output 1
add_interface_port conduit_end SRAM_LB_N export Output 1
add_interface_port conduit_end SRAM_WE_N export Output 1
add_interface_port conduit_end SRAM_CE_N export Output 1
add_interface_port conduit_end SRAM_OE_N export Output 1

