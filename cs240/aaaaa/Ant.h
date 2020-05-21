#ifndef ANT_H
#define ANT_H


class Ant{
	private:
		int id;
		int x;
		int y;
		int exp;
	public:
		Ant(){id=-1;};
		Ant(int);
		int getID(){return this->id;};
		void move();
		int getX(){return this->x;};
		int getY(){return this->y;};
		int get_exp(){return this->exp;};
		Ant * fight(Ant *);
		//write any additional functions on your own.
};

#endif
