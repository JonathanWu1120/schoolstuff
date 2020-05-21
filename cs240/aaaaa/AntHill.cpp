#include "AntHill.h"
#include "Ant.h"
#include <iostream>
#include <cstdlib>

#define BUFFER_MAX 100

using namespace std;


AntHill::AntHill(int max){
	this->max_ants = max;
	this->next_id = 0;
}
bool AntHill::addAnt(){
	if(current_ants >= max_ants) return false;
	this->ants[current_ants] = Ant(this->next_id);
	current_ants++;
	next_id++;
	return true;
}
Ant AntHill::getAnt(int index){
	return ants[index];
}
void AntHill::move(){
	for(int i = 0; i < current_ants; i++){
		ants[i].move();
	}
}
bool AntHill::changeMax(int new_max){
	if(new_max <= 100 && new_max > 0){
		this->max_ants = new_max;
		return true;
	}return false;
}
void AntHill::printHillInfo(){
	for(int i = 0; i < getCurrentNumAnts(); i++){
		cout << "Ant #" << ants[i].getID() << "[" << ants[i].getX() << "," << ants[i].getY() << "]" << endl;
	}
}
int AntHill::getCurrentNumAnts(){ 
	return this->current_ants;
}
int AntHill::getMaxAnts(){ 
	return this->max_ants;
}

