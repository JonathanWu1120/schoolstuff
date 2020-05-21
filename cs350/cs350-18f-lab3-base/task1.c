#include <stdio.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <unistd.h>

int main(void) {
	int status;
	pid_t pid = fork(); 
	if(pid == 0){
		pid_t grand = fork();
		printf("GRancdhild = %d\n",grand);
		printf("IN CHILD: pid = %d\n",pid);
		char *args[] = {"ls","-l","-a",0};
		execvp(args[0],args);
		//execv("/bin/ls",args);
	}else{
		wait(&status);
		printf("IN PARENT: successfully waiting child (pid=%d)\n",pid);
	}
    	return 0;
}
