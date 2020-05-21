#include "STree.h"

STree::STree(int p){
	this->root = new Node(0,0,p);
}

void STree::insl(int weight, int price, int profit, Node* root){
	root->left = new Node(root->weight+weight,root->profit+price,profit);
}

void STree::insr(int profit, Node* root){
	root->right = new Node(root->weight,root->profit,profit);
}

STree::~STree(){
	delete_tree(this->root);
}

void STree::delete_tree(Node *root){
	if(root != nullptr){
		if(root->left!=nullptr){
			delete_tree(root->left);
		}
		if(root->right!=nullptr){
			delete_tree(root->right);
		}
		delete root;
	}
}


