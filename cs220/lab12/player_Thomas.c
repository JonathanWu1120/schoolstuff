#include <stdlib.h>

rps player_jwu166(int round, rps *myhist, rps *opphist){
	int rock = 1;
	int paper = 1;
	int sci = 1;
	for(int i = 0; i < round; i++){
		if(opphist[i]==Rock){
			paper++;
		}else if(opphist[i]==Paper){
			sci++;
		}else if(opphist[i]==Scissors){
			rock++;
		}
	}
	int r = rand() % (rock+paper+sci);
	if(r < rock){
		return Rock;
	}else if (r >= rock && r < rock+paper){
		return Paper;
	}
	return Scissors;
}

register_player(player_jwu166,"jwu166");
