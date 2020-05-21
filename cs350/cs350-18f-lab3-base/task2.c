#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>

int main(int argc, char * argv[]) {
	int status;
    	pid_t pid = fork();
	if(pid == 0){
		printf("IN CHILD: pid = %d\n",pid);
		char *args[argc];
		for(int i = 1; i < argc;i++){
			args[i-1] = argv[i];
		}
		args[argc] = 0;
		execvp(args[0],args);
	}else{
		wait(&status);
		printf("IN PARENT: successflly waiting child (pid=%d)\n",pid);
	}	
    return 0;
}
