#include "item.h"

Item::Item(int c, int w){
	this->cost = c;
	this->weight = w;
	this->ratio = c/w;
}

int Item::getc(){
	return this->cost;
}

int Item::getw(){
	return this->weight;
}

float Item::getr(){
	return this->ratio;
}

bool Item::operator<(const Item &other){
	return (this->ratio < other.ratio);
}


