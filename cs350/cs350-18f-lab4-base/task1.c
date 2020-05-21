#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void) {
    int status;
    char * argv1[] = {"cat", "Makefile", 0};
    char * argv2[] = {"head", "-4", 0};
    //char * argv2[] = {"wc", "-l", 0};
    int pipeA[2];
    int pid_a, pid_b;
    pipe(pipeA);
    pid_a = fork();
    if(pid_a == 0){
	    printf("In CHILD-1 (PID=%d): executing command %s\n",pid_a,argv1[0]);
	    dup2(pipeA[1],1);
	    close(pipeA[0]);
	    execvp(argv1[0],argv1);
    }else{
	    pid_b = fork();
	    if(pid_b == 0){
		    printf("In CHILD-2 (PID=%d): executing command %s\n)",pid_b,argv2[0]);
		    dup2(pipeA[0],0);
		    close(pipeA[1]);
		    execvp(argv2[0],argv2);
	    }else{
		    sleep(1);
		    printf("In PARENT (PID = %d): successfully reaped child\n",pid_a);
	    }

    }
    wait(&status);
    printf("In PARENT (PID=%d): successfully reaped child\n",pid_b);
    /*dup2(pipefd[1],1);
      close(pipefd[0]);
      execvp(argv1[0],argv1);*/

setbuf(stdout, NULL);



    return 0;
}
