#include <iostream>
#include <chrono>
#include "Node.h"
#include <sstream>
#include <algorithm>
#include <string>
#include <fstream>
#include <vector>
#include <stdio.h>
#include "item.h"

int backtrack(std::vector<int>,std::vector<int>,int,int);
int compute(std::vector<int>,int);
int greedy_one(std::vector<Item>,int);
int greedy_two(std::vector<Item>,int);
int backtrack(std::vector<Item> items,int w, int n,int maxp);

int main(int argc, char* argv[]){
	std::ifstream inputf;
	std::ofstream outputf;
	inputf.open(argv[1]);
	outputf.open(argv[2]);
	int a = std::stoi(argv[3]);
	if(inputf.is_open()){
		std::vector<int> nums;
		std::string str;
		while(std::getline(inputf,str)){
			std::istringstream is(str);
			int a;
			int b;
			is >> a;
			is >> b;
			nums.push_back(a);
			nums.push_back(b);
		}

		//std::vector<Item> item_list = make_list(inputf);	
		//int counter = 0;
		//for(Item i : item_list){
		//	counter++;
		//	std::cout << i.getc() << i.getw() << "item" << counter << i.getr() << std::endl;
		//}		
		inputf.close();
		std::vector<std::vector<int>> case_list;
		while(!nums.empty()){
			std::vector<int> v;
			int cases = nums[0];
			for(int i = 0; i <= cases; i++){
				v.push_back(nums[0]);
				nums.erase(nums.begin());
				v.push_back(nums[0]);
				nums.erase(nums.begin());
			}
			case_list.push_back(v);
		
		}
		for(std::vector<int> v : case_list){
			std::chrono::high_resolution_clock::time_point t1 = std::chrono::high_resolution_clock::now();
			int profit = compute(v,a);
			std::chrono::high_resolution_clock::time_point t2 = std::chrono::high_resolution_clock::now();
			auto duration = std::chrono::duration_cast<std::chrono::microseconds>(t2-t1).count();
			duration /= 1000000;
			outputf << v.size()/2-1 << " " << profit  << " " << duration << std::endl;
		}
	}
	outputf.close();
}	


int compute(std::vector<int> v,int algo){
	std::vector<Item> item_list;
	int items = v[0];
	int weight = v[1];
	for(int i = 0; i <items;i++){
		Item item(v[i*2+3],v[i*2+2]);
		item_list.push_back(item);
	}
	std::sort (item_list.begin(),item_list.begin()+items);
	//for(Item i: item_list){
	//	std::cout << i.getc() << i.getw() << "ratio" << i.getr() << std::endl;
	//}
//	std::reverse(item_list.begin(),item_list.end());
	int max_profit;
	std::reverse(item_list.begin(),item_list.end());
	if(algo == 0){
		max_profit = greedy_one(item_list,weight);
	}else if(algo == 1){
		max_profit = greedy_two(item_list,weight);
	}else{
//	for(Item i : item_list){
	//	std::cout << i.getw() << " " << i.getc() << std::endl;
		std::vector<int> weights;
		std::vector<int> prices;
		for(Item i : item_list){
			weights.push_back(i.getw());
			prices.push_back(i.getc());
		}
		std::vector<int> bestset;
		std::vector<int> include;
		//Node n(0,0,maxp);
		max_profit = backtrack(weights,prices,weight,weights.size());
//	}
	//std::cout << item_list.size() << std::endl;
	}
	return max_profit;
//	std::cout << max_profit << std::endl;
}

int backtrack(std::vector<int> weights,std::vector<int> prices,int w,int n){
	int table[n+1][w+1];
	for(int i = 0; i <= n; i++){
		for(int we = 0; we <= w; we++){ 
			//solution starting from the bottom
			if(i==0 || we==0){
				table[i][we] = 0;
			}
			else if(weights[i-1] <= we){
				table[i][we] = std::max(table[i-1][we],prices[i-1]+table[i-1][we-weights[i-1]]);
			}else{
				table[i][we] = table[i-1][we];
			}
		}
	}	
	return table[n][w];
}

int greedy_one(std::vector<Item> items,int w){
	int track = 0;
	int profit = 0;
	while(track < items.capacity()){
		if(items[track].getw() <= w){
			profit += items[track].getc();
			w -= items[track].getw();
		}
		track++;
	}
	return profit;
}
int greedy_two(std::vector<Item> items,int w){
	int profit = greedy_one(items,w);
	int max = 0;
	for(Item i : items){
		if(i.getw() <= w && i.getc() > max){
			max = i.getc();
		}
	}
	if(max > profit){
		return max;
	}
	return profit;
}

