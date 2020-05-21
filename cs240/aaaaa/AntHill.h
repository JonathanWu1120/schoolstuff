#ifndef ANTHILL_H
#define ANTHILL_H

class AntHill{
	private:
		int max_ants;
		int current_ants;
		Ant ants[100];
		int next_id;
	public:
		AntHill(int);
		bool addAnt();
		Ant getAnt(int);
		void move();
		bool changeMax(int);
		void printHillInfo();
		int getCurrentNumAnts();
		int getMaxAnts();



};

#endif
