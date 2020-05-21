#ifndef HEAP_H
#define HEAP_H
#include <utility>
#include <vector>
#include <iostream>

class Heap{
	private:
		std::vector<std::pair<int,int>> arr;
		int capacity;
		int cur_size;
		std::vector<int> handle;
	public:
		Heap(int);
		//bool empty();
		int findContestant(int);
		bool insertContestant(int,int);
		std::pair<int,int> eliminateWeakest(int);
		bool earnPoints(int,int);
		bool losePoints(int,int);
		bool points(int,int,bool);
		void showContestants();
		void showHandles();
		bool showLocation(int);
		void crownWinner();
		void reheapify(int);
		void swap(std::pair<int,int>*,std::pair<int,int>*);
		int parent(int i){return (i-1)/2;};
		int left(int i){return (2*i+1);};
		int right(int i){return (2*i+2);};

};
#endif
