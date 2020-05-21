#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

//pthread_mutext_t lock = PTHREAD_MUTEX_INITIALIZER;
int count1 = 0;
int count2 = 0;

typedef struct{
	int *arg;
	char **args;
}arg;

void *print_args(void *args){
	arg *print_stuff = args;
	for(int i = 0; i < *print_stuff->arg; i++){
		printf("%c", print_stuff->args[i*sizeof(char)]);
	}
	printf("\n");
	free(print_stuff);
	count1++;
	return 0;
}
void *rprint_args(void *args){
	arg *print_stuff = args;
	for(int i = *print_stuff->arg-1; i > 0; i--){
		printf("%c ", print_stuff->args[i]);
	}
	printf("\n");
	free(print_stuff);
	count2++;
	return 0;
}
int main(int argc, char* argv[]){
	if(argc < 3){
		printf("There must be 2 arguments following the binary!\n");
		return 0;
	}
	pthread_t t1;
	pthread_t t2;
	int times = atoi(argv[1]);
	while(times > 0){
		arg *stp = malloc(sizeof *stp);
		stp->arg = &argc;
		stp->args = argv;
		if(pthread_create(&t1,NULL,print_args,&stp)){
			free(stp);
		}
		/*else if(pthread_create(&t2,NULL,rprint_args,&stp)){
			free(stp);
		}*/
		times--;
	}
	printf("%d %d \n",count1,count2);

	return 0;
}
