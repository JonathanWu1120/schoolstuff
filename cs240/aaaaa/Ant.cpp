#include "Ant.h"
#include <iostream>
#include <cstdlib>

Ant::Ant(int id){
	this->id = id;
	this->x = this->y = this->exp = 0;
}

void Ant::move(){
	int location = rand() % 4;
	if(location == 0) this->x++;
	else if (location == 1)  this->y++;
	else if (location == 2)  this->x--;
	else if (location == 3)  this->y--;
}

Ant * Ant::fight(Ant * opponent){
	int winner = rand() % 1000;
	int difference = this->exp - opponent->exp;
	int win_threshold = 499;
	if(difference != 0){
		if(abs(difference) > 400){
			win_threshold += 400;
		}else{
			win_threshold += difference;
		}
	}
	if(winner > win_threshold){
		return opponent;
	}
	return this;
}

