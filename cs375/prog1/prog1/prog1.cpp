#include <iostream>
#include <math.h>
#include <fstream>
#include <iomanip>
#include <unordered_map>
#include <vector>
#include <string.h>
#include <stdio.h>
#include <chrono>

using namespace std;
using namespace std::chrono;
pair<int,int> compute_profit(unordered_map<std::string,int>, vector<pair<std::string,int>>,int);

int main(int argc, char* argv[]){
	if(argc != 5){
		cout << "Not enough arguements" << endl;
		exit(1);
	}
	ifstream market;
	ifstream price;
	if(strcmp(argv[1],"-m")==0){
		market.open(argv[2]);
		if(strcmp(argv[3],"-p")==0){
			price.open(argv[4]);
		}else{
			cout << "Invalid flag" << endl;
			exit(1);
		}
	}else if(strcmp(argv[1],"-p")==0){
		price.open(argv[2]);
		if(strcmp(argv[3],"-m")==0){
			market.open(argv[4]);
		}else{
			cout << "invalid flag" << endl;
		}
	}
	if(market.is_open()){
		int x;
		market >> x;
		unordered_map<std::string,int> m;
		for(int i = 0; i < x; i++){
			string card;
			int m_price;
			market >> card;
			market >> m_price;
			m[card] = m_price;
		}
		if(price.is_open()){
			int cards = 0;
			ofstream output;
			output.open("output.txt");

			while(price >> cards || !price.eof()){
				high_resolution_clock::time_point t1 = high_resolution_clock::now();
				int total_money;
				price >> total_money;
				int total_card_price = 0;
				vector<pair<std::string,int>> p;
				for(int i = 0; i < cards; i++){
					string card;
					int money;
					pair<std::string,int> card_info;
					price >> card;
					price >> money;
					total_card_price += money;
					if(m.count(card)==0){
						cout << "Card named : " << card << "  is not in market price" << endl;
						exit(1);
					}else{
						if(money <= total_money){
							card_info.first = card;
							card_info.second = money;
							p.push_back(card_info);
						}
					}
				}
				int profit = 0;
				int bought = 0;
				pair<int,int> card_profit;
				if(total_money >= total_card_price){
					for(auto kv: p){
						profit += m[kv.first] - kv.second;
						bought++;
					}
				//	cout << "Enough money for all cards" << endl;
					card_profit.first = profit;
					card_profit.second = bought;
				}else{
					//do some stuff
					card_profit = compute_profit(m,p,total_money);
				}
				high_resolution_clock::time_point t2 = high_resolution_clock::now();
				auto duration = duration_cast<microseconds>(t2-t1).count();
				duration /= 1000000;
				output << cards << "  " << card_profit.first << "  " << card_profit.second<< "  " << duration << endl;
				//cout << cards << "  " << card_profit.first << "  " << card_profit.second<< "  " << duration ;
			}
			output.close();
		}else{
			cout <<"Error in opening price file" << endl;
		}
	}else{
		cout<< "Error in opening market file" << endl;
		exit(1);
	}
	return 0;
}

pair<int,int> compute_profit(unordered_map<std::string,int>m, vector<pair<std::string,int>>p,int money){
	int max_profit = 0;
	int cards_bought = 0;
	pair<int,int> ret;
	vector<pair<std::string,int>> subset;
	unsigned int pow_set_size = pow(2, p.size());
	for(unsigned int i = 0; i <pow_set_size;i++){
		int cur_profit = 0;
		int spent = 0;
		subset.clear();
		for(unsigned int j = 0; j < p.size();j++){
			if(i&(1<<j)){
				subset.push_back(p[j]);
			}
		}
		for(unsigned int j = 0; j<subset.size();j++){
			string name = subset[j].first;
			cur_profit += m[name] - subset[j].second;
			spent += subset[j].second;
		}
		if(cur_profit > max_profit && spent <= money){
			max_profit = cur_profit;
			cards_bought = subset.size();
			ret.first = max_profit;
			ret.second = cards_bought;
		}
	}

	return ret;
}
