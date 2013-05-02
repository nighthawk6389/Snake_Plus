#ifndef _FREEZE_H_
#define _FREEZE_H_

#include "snake_io.h"
#include "powboard.h"
#include "constants.h"


void initFreeze(struct Freeze freeze[], int board[X_LEN][Y_LEN]){
	printf("Initializing freeze\n");
	int i;
	int j;
	int count = 0;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			if(board[i][j] == 1){
				freeze[count].enable = 0;
				freeze[count].xCoord = i;
				freeze[count].yCoord = j;
				count++;
			}
		}
	}

	shuffle_freeze(freeze,MAX_POWERUP_SIZE);
}

int checkFreeze(struct Snake snake[], struct Freeze freeze[], int player, struct SnakeInfo * info){

	int j;
	for(j = 0; j < MAX_POWERUP_SIZE; j++){
		if(freeze[j].enable){
			int xDiff = abs(snake[0].xCoord - freeze[j].xCoord*16);
			int yDiff = abs(snake[0].yCoord - freeze[j].yCoord*16);
			//printf("snake x: %d y: %d\n",snake[0].xCoord, snake[0].yCoord);
			if(xDiff <= col_offset && yDiff <= col_offset){
				printf("Eating Freeze!\n");
				removeFreeze(freeze,j);
				info->has_freeze = 1;
				if(freeze_index == MAX_POWERUP_SIZE){
					freeze_index = 0;
				}
				while( !drawFreeze(freeze) );
				break;
			}
		}
	}
	return 0;
}

void apply_freeze(struct Snake snake[], struct Freeze freeze[], int player, struct SnakeInfo * info){

	if( !info->has_freeze ){
		printf("PLAYER%d DOESNT HAVE FREEZE\n", player);
		return;
	}

	printf("PLAYER%d used his freeze\n",player);
	info->has_freeze = 0;
	info->freeze_enabled = 1;
	info->freeze_count = 0;

	if(player == PLAYER1){
		PLAYER2_SLEEP_CYCLES 	= FREEZE_SLEEP_CYCLE / SLEEP_TIME;
	} else{
		PLAYER1_SLEEP_CYCLES 	= FREEZE_SLEEP_CYCLE / SLEEP_TIME;
	}

}

int recalc_freeze_times(struct Snake snake[], struct Freeze freeze[], int player, struct SnakeInfo * info){

	if(info->freeze_enabled){
		info->freeze_count++;
		if(info->freeze_count >=  FREEZE_TIME){
			info->freeze_enabled = 0;
			info->freeze_count = 0;
			if(player == PLAYER1){
				PLAYER2_SLEEP_CYCLES 	= DEFAULT_SLEEP_CYCLE / SLEEP_TIME;
			}else{
				PLAYER1_SLEEP_CYCLES 	= DEFAULT_SLEEP_CYCLE / SLEEP_TIME;
			}

		}
	}
	return 1;
}

int drawFreeze(struct Freeze freeze[]){

	if((freeze[freeze_index].xCoord <= 2 || freeze[freeze_index].xCoord >= X_LEN-1)
			|| (freeze[freeze_index].yCoord <= 2 || freeze[freeze_index].yCoord >= Y_LEN-1)){
		freeze_index++;
		return 0;
	}

	short t_xCoord = freeze[freeze_index].xCoord;
	short t_yCoord = freeze[freeze_index].yCoord;

	if(brick_tiles[t_xCoord][t_yCoord]){
		return 0;
	}
	freeze[freeze_index].enable = 1;
	printf("Freeze ENABLED at x: %d y: %d\n",freeze[freeze_index].xCoord, freeze[freeze_index].yCoord);
	addTilePiece(FREEZE_CODE, (short) freeze[freeze_index].xCoord, (short) freeze[freeze_index].yCoord);

	printf("Freeze index: %d\n", freeze_index);
	freeze_index++;

	return 1;
}

void removeFreeze(struct Freeze freeze[], int index){
	printf("Removing freeze\n");
	freeze[index].enable = 0;
	removeTilePiece((short) freeze[index].xCoord, (short) freeze[index].yCoord);
}

void shuffle_freeze(struct Freeze arr[], int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		struct Freeze temp = arr[index];
		arr[index] = arr[i];
		arr[i] = temp;
	}
}

#endif
