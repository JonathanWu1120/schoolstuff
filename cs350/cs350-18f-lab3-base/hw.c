#include <stdio.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <unistd.h>

int main(void){
	int i = 0;
	printf("A");
	i++;
	fork();
	printf("B");
	i++;
	fork();
	printf("C");
	i++;
	fork();
	printf("D");
	i++;
	printf("%d\n",i);
	return 0;
}
