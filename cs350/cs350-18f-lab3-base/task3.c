#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>

#define INPUT_FILE "./input/if1"

int main(int argc, char * argv[]) {
	int status;
	pid_t pid = fork();
	if(pid == 0){
		printf("IN CHILD: pid=%d\n",pid);
		char *args[argc+1];
		for(int i = 1; i < argc; i++){
			args[i-1] = argv[i];
		}
		args[argc] = INPUT_FILE;
		args[argc+1] = 0;
		int in = open(INPUT_FILE, O_RDWR);
		int out = open("result",O_WRONLY | O_CREAT, S_IRUSR );
		dup2(in,0);
		dup2(out,1);
		execvp(args[0],args);
		close(in);
		close(out);
	}else{
		wait(&status);
		printf("IN PARENT: successfully waiting child (pid=%d)\n",pid);
	}	
    return 0;
}
