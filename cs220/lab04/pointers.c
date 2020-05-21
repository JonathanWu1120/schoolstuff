#include <stdio.h>


void increment(int *counter);
void swap_temp(int *a, int *b);
void swap_notemp(int *a, int *b);

int getBit(int *in,int ind);
void setBit(int *in,int ind,int val);

int main(int argc,char **argv) {
	printf("argc is at location %p\n",&argc);
	int counter=0;
	printf("counter variable is at location %p\n",&counter );
	printf("counter value is %d\n",counter);
	/* Invoke the increment function to increment the value of counter here */
	int *ptr_counter = &counter;
	increment(ptr_counter);
	printf("counter value after increment is %d\n",counter);
	int a=17;
	int b=24;
	int *a_ptr = &a;
	int *b_ptr = &b;
	printf("Before any swap, a=%d and b=%d\n",a,b);
	/* Invoke the swap_temp function to switch the values of a and b */
	swap_temp(a_ptr,b_ptr);
	printf("After swap_temp, a=%d and b=%d\n",a,b);
	/* Invoke the swap_notemp function to switch the values of a and b again */
	swap_notemp(a_ptr,b_ptr);
	printf("After swap_notemp, a=%d and b=%d\n",a,b);
	int vec[6]={10,11,12,13,14,15};
	printf("vec variable is at location %p\n",vec);
	printf("vec vector index 0 is at %p\n",&vec[0]);
	printf("vec vector index 1 is at %p\n",&vec[1]);
	printf("vec vector index 5 is at %p\n",&vec[5]);
	printf("Difference between location of vec[0] and vec[5] is %d\n",
			(int)(&vec[5]-&vec[0]));
return 0;
}

/* Insert code for increment, swap_temp, and swap_notemp here */
void increment(int *counter){
	(*counter) ++;
}
void swap_temp(int *a, int *b){
	int temp = *a;
	*a = *b;
	*b = temp;
}
void swap_notemp(int *a, int *b){
	*a = *a ^ *b;
	*b = *a ^ *b;
	*a = *a ^ *b;

}
int getBit(int *in,int ind) {
	unsigned int mask = 1;
	mask= mask<<ind; // Shift the 1 in the rightmost bit to the left ind positions
	if (mask & (*in)) return 1;
	return 0;
}

void setBit(int *in,int ind,int val) {
	unsigned int mask=1;
	mask = mask<<ind; // Shift the 1 in the rightmost bit to the left ind positions
	if (val) (*in) |= mask; // Turn on bit under mask
	else (*in) &=~mask; // Turn off bit under mask
}
