#ifndef NODE_H
#define NODE_H

class Node{
	public:
		Node(int a,int b, int c){
			this->profit = a;
			this->weight = b;
			this->bound = c;
		}
		int profit;
		int weight;
		int bound;
		bool promising(int maxw,int maxp){
			if(bound > maxp && weight <= maxw){
				return true;
			}
			return false;
		}
};

#endif
