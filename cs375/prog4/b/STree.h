#ifndef STREE_H
#define STREE_H

class STree{
	private:
		class Node{
			public:
				Node(int a, int b, int c){
					weight = a;
					profit = b;
					bound = c;
					left = nullptr;
					right = nullptr;
					parent = nullptr;
				}
				int weight;
				int profit;
				int bound;
				Node* parent;
				Node* left;
				Node* right;
		};
	public:
		Node* root;
		STree(){
			root = nullptr;
		}
		STree(int);
		void insl(int,int,int,Node*);
		void insr(int,Node*);
		void delete_tree(Node*);
		bool promising(Node*);
		~STree();
};

#endif
