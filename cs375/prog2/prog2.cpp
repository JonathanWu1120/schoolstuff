#include "heap.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <iterator>
#include <map>
#include <string>

using namespace std;

typedef int(*FnPtr)(int,int);

int main(){
	ifstream inData;
	string fileName;
	cout << "Enter input file name: ";
	cin >> fileName;
	inData.open(fileName.c_str());
	if(!inData){
		cout << "Unable to open file" << endl;
		exit(1);
	}
	string line;
	int size;
	getline(inData,line);
	size = stoi(line);
	Heap *h = new Heap(size);
	while(getline(inData,line)){
		cout << line << '\n';
		istringstream iss(line);
		vector<string> arguement(istream_iterator<string>{iss},istream_iterator<string>());
		string s = arguement[0];
		if(s.compare("insertContestant") == 0){
			int a = stoi(arguement[1].substr(1));
			int b = stoi(arguement[2].substr(1));
			h->insertContestant(a,b);
		}
		if(s.compare("showContestants") == 0){
			h->showContestants();
		}
		if(s.compare("findContestant") == 0){
			h->findContestant(stoi(arguement[1].substr(1)));
		}
		if(s.compare("eliminateWeakest")== 0){
			h->eliminateWeakest(0);
		}
		if(s.compare("earnPoints") == 0){
			h->earnPoints(stoi(arguement[1].substr(1)),stoi(arguement[2].substr(1)));
		}
		if(s.compare("losePoints") == 0){
			h->losePoints(stoi(arguement[1].substr(1)),stoi(arguement[2].substr(1)));
		}
		if(s.compare("showHandles") == 0){
			h->showHandles();
		}
		if(s.compare("crownWinner") == 0){
			h->crownWinner();
		}
	}
	inData.close();

	return 0;
}
