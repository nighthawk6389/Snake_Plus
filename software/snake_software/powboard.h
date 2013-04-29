#ifndef _POWBOARD_H_
#define _POWBOARD_H_
#define X_LEN 40
#define Y_LEN 30
int x[X_LEN];
int y[Y_LEN];

unsigned int seed = 5323;

int PRNG(int n){
	seed = (8253729 * seed + + 2396403);
	return seed % n;
}

void shuffle(int arr[], int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		int temp = arr[index];
		arr[index] = arr[i];
		arr[i] = temp;
	}
}

void initPowBoard(int board[X_LEN][Y_LEN]){
	int i;
	for (i = 0; i < X_LEN; i++){
		x[i] = i;		
	}
	shuffle(x, X_LEN);
	for (i = 0; i < Y_LEN; i++){
		y[i] = i;				
	}
	shuffle(y, Y_LEN);
	
	int count = 0;
	i = 0;
	int k;
	int j;
	for(k = 0; k < X_LEN; k++){
		for(j = 0; j < Y_LEN; j++){
			if(i == 3){
				i = 0;
			}
			//printf("%d type: %d at loc: %d,%d\n", count, i, x[k], y[j]);
			board[x[k]][y[j]] = i;
			count++;
			i++;
		}
	}
	//return board;
}
#endif
