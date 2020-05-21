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
    char * argv3[] = {"wc", "-l", 0};
    int pipeA[2];
    int pipeB[2];
    int pid_a, pid_b,pid_c;
    pipe(pipeA);
    pipe(pipeB);
    pid_a = fork();
    if(pid_a == 0){
	    printf("In CHILD-1 (PID=%d): executing command %s\n",pid_a,argv1[0]);	    
	    dup2(pipeA[1],1);
	    close(pipeA[0]);
	    execvp(argv1[0],argv1);
    }else{
	    pid_b = fork();
	    if(pid_b == 0){
		    printf("In CHILD-2 (PID=%d): executing command %s\n",pid_b,argv2[0]);
		    dup2(pipeA[0],0);
		    dup2(pipeB[1],1);
		    close(pipeA[1]);
		    close(pipeB[0]);
		    execvp(argv2[0],argv2);
	    }else{
		    pid_c = fork();
		    if(pid_c == 0){
			    printf("In CHILD-3 (PID=%d): executing command %s\n",pid_c,argv3[0]);
			    dup2(pipeB[0],0);
			    close(pipeB[1]);
			    execvp(argv3[0],argv3);
		    }
	    }
    }
    wait(&status);
    printf("In PARENT (PID=%d): successfully reaped child (PID=%d)\n",pid_a,pid_a);

    setbuf(stdout, NULL);


    return 0;
}
