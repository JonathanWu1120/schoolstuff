/* ------------------------------------------------------------------
Pick marbles from a jar that contains a mixture of:
	100 red marbles,
	100 blue marbles, and
	100 green marbles.


How many marbles did you need to pick to get 10 red?

-------------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int redMarbles=100;
int greenMarbles=100;
int blueMarbles=100;
int red_count;
int blue_count;
int green_count;
int red_amount = 0;

void add_red(){
	red_count ++;
	red_amount ++;
}

char pickMarble() {
	char picked='?';
	int tot = redMarbles + greenMarbles + blueMarbles;
	assert(tot>0);
	int choice = rand()%tot; // Choice is a random number 0 <= choice < tot
	if (choice<redMarbles) {
		redMarbles = redMarbles - 1;
		//printf("Picked a red marble\n");
		picked='r';
	}
	else if (choice<redMarbles+greenMarbles) {
		greenMarbles = greenMarbles - 1;
		//printf("Picked a green marble\n");
		picked='g';
	}
	else {
		blueMarbles = blueMarbles - 1;
		//printf("Picked a blue marble\n");
		picked='b';
	}
	return picked;
}

void turn(){
	char marble = pickMarble();
	red_count = 0;	
	green_count = 0;
	blue_count = 0;
	if (marble == 'r'){
		add_red();
		char picked = pickMarble();
		while(red_amount < 50){
			picked = pickMarble();
			if (picked == 'r') add_red();
			else if (picked == 'b') {
				blue_count++;
				break;
			}
		}
	}else if (marble == 'g'){
		green_count ++;
		char green_pick = pickMarble();
		char prev = green_pick;
		while(red_amount < 50){
			green_pick = pickMarble();
			if (green_pick == 'r'){
				add_red();
			}else if (green_pick == 'g'){
				green_count ++;
			}else if (green_pick == 'b'){
				blue_count ++;
			}
			if(prev == green_pick) break;
			prev = green_pick;
		}
	}else if (marble == 'b'){
		blue_count ++;
		redMarbles = 100;
		//greenMarbles = 100;
		//blueMarbles = 100;
		red_amount = 0;
		//printf("Marbles have been reset");
	}
	printf("You have picked %d red marbles, %d blue marbles, and %d green marbles\n", red_count, blue_count, green_count);
}

int main(int argc, char ** argv) {
	if (argc>1) { srand(atoi(argv[1])); } // Seed random number
	int numPicked=0;
	while(red_amount < 50) {
		turn();
		numPicked=numPicked+1;
	}
	printf("Got 50 red marbles after %d turns.\n",numPicked);
	return 0;
}
