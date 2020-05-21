#ifndef ITEM_H
#define ITEM_H

class Item{
	private:
		int weight;
		int cost;
		float ratio;
	public:
		Item(int,int);
		int getw();
		int getc();
		float getr();
		bool operator<(const Item &other);
};
#endif
