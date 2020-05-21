#include "heap.h"
#include <utility>
#include <iostream>
#include <vector>

Heap::Heap(int i){
	capacity = i;
	cur_size = 0;
	for(int j = 0; j < i ;j++){
		this->handle.push_back(0);
	}
}

//bool Heap::empty(){
//	return (this->arr[0] == NULL);
//}

int Heap::findContestant(int id){
	if(this->handle[id-1]-1 >= 0){
		std::cout << "Contestant <" << id << "> is in the extended heap with score <" << arr[this->handle[id-1]-1].second << ">." << std::endl;
		return this->handle[id-1];
	}
	else{
		std::cout << "Contestant <" << id << "> is not in the extended heap." << std::endl;
		return 1;
	}
}

void Heap::swap(std::pair<int,int> *p,std::pair<int,int> *q){
	std::pair<int,int> temp = *p;
	int a = handle[p->first-1];
	handle[p->first-1] = handle[q->first-1];
	handle[q->first-1] = a;
	*p = *q;
	*q = temp;
}

bool Heap::insertContestant(int id, int score){
	if(cur_size == capacity){
		std::cout << "Contestant <" << id << "> could not be inserted because the extended heap is full."  << std::endl;
		return 0;
	}
	if(this->handle[id-1]){
		std::cout << "Contestant <" << id << "> is already in the extended heap: cannot insert." << std::endl;
		return 0;
	}
	cur_size++;
	int i = cur_size - 1;
	std::pair<int,int> p;
	p.first = id;
	p.second = score;
	arr.insert(arr.begin()+i,p);
	//arr.push_back(p);
	std::cout << "Contestant <" << p.first << "> inserted with initial score <" << p.second << ">." << std::endl;
	handle[id-1] = id;
	while(i != 0 && arr[parent(i)].second > arr[i].second){
		swap(&arr[i],&arr[parent(i)]);
		i = parent(i);
	}
	return 1;
}	

bool Heap::earnPoints(int id, int point){
	return points(id,point,true);
}

bool Heap::losePoints(int id, int point){
	return points(id,point,false);
}

bool Heap::points(int id, int points, bool b){
	//std::cout << id << std::endl;
	if(this->handle[id-1] == -1){
		std::cout << "Contestant <" << id << "> is not in the extended heap." << std::endl;
		return 0;
	}
	int index = this->handle[id-1]-1;
	//std::cout << index << std::endl;
//	for(auto a : arr){
//		std::cout << a.first << " " << a.second << std::endl;
//	}
	if(index >=0){
		if(b){
		//	std::cout << arr[index].second << std::endl;
			arr[index].second += points;
			std::cout << "Contestant <" << arr[index].first << ">s score increased by <" << points << "> points to <" <<arr[index].second << ">." << std::endl;
		//	std::cout << arr[index].second << std::endl;
		}else{
		//	std::cout << arr[index].first << " " << arr[index].second << std::endl;
			arr[index].second -= points;
			std::cout << "Contestant <" << arr[index].first << ">s score decreased by <" << points << "> points to <" << arr[index].second << ">." << std::endl;
		//	std::cout << arr[index].first << " " << arr[index].second << std::endl;
		}
		reheapify(index);
		//have to reheapify
		return true;
	}else{
		std::cout << "Contestant " << id << " is not in the extended heap" << std::endl;
	}
	return false;
}

void Heap::showContestants(){
	int count = 1;
	for(auto p: arr){
		std::cout << "Contestant <" << p.first << "> in extended heap location <" << count << "> with score <" << p.second <<">." << std::endl;
		count++;
	}
}

void Heap::showHandles(){
	int count = 1;
	for(int j = 0; j < capacity;j++){
		int i = handle[j];
		if(i-1 >= 0){
			std::cout << "Contestant <" << count << "> stored in extended heap location <" << i << ">." << std::endl;
		}else{
			std::cout << "There is no Contestant <" << count << "> in the extended heap: handle[<" <<count<<">] = -1." << std::endl;
		}
		count ++;
	}
}	

bool Heap::showLocation(int id){
	if(handle[id-1]-1 >= 0){
		std::cout << "Contestant <" << id << "> stored in extended heap location <" << handle[id-1] << ">." << std::endl;
		return true;
	}else{
		std::cout << "There is no Contestant <" << id << "> in the extended heap: handle[<" << id<<">] = -1." << std::endl;
		return false;
	}
}

std::pair<int,int> Heap::eliminateWeakest(int o){
	if(cur_size == 0){
		std::cout << "No contestant can be eliminated since the extended heap is empty." << std::endl;
		std::pair<int,int> r;
		return r;
	}
	if(o == 2){
		std::cout << "Contestant <" << arr[0].first << "> wins with score <" << arr[0].second << ">!" << std::endl;
		return arr[0];
	}
	if(cur_size == 1){
		cur_size--;
		std::pair<int,int> r = arr[0];
		arr.erase(arr.begin());
		std::cout << "Contestant <" << r.first << "> with current lowest score <" <<r.second <<"> eliminated." << std::endl;
		return r;
	}
	std::pair<int,int> p = arr[0];
	arr[0] = arr[cur_size-1];
	arr.pop_back();
	handle[arr[0].first-1] = 1;
	handle[p.first-1] = -1;
	if(o == 0){
		std::cout << "Contestant <" << p.first << "> with current lowest score <" << p.second <<"> eliminated." << std::endl;
	}
	cur_size--;
	reheapify(0);
	return p;
}

void Heap::reheapify(int i){
	int l = left(i);
	int r = right(i);
	int smallest = i;
	if(l < cur_size && arr[l].second < arr[i].second){
		smallest = l;
	}
	if(r < cur_size && arr[r].second < arr[i].second){
		smallest = r;
	}
	if(smallest != i){
		swap(&arr[i],&arr[smallest]);
		reheapify(smallest);
	}
}

void Heap::crownWinner(){
	while(cur_size > 1){
		eliminateWeakest(1);
	}
	eliminateWeakest(2);
}


//make reheapify
//make swap
