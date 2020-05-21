#include "types.h"
#include "stat.h"
#include "user.h"

#define STUB_FUNCS
#ifdef STUB_FUNCS
void my_sleep(int secs){
	for(int i = secs; i > 0; i--){
		printf(1, "%d ",i);
		sleep(100);
	}
}
//extern int my_sleep();
void shutdown(int waitsecs, char * msg) {
	my_sleep(waitsecs);	
	printf(1, "%s\n", msg);
	shutdown2();
}


#endif

#define USAGE_STR \
"usage: shutdown2 delay_seconds custom_word \n\
  delay_seconds: number of seconds delayed before shutdown.\n\
  custom_word: word to display after the dealy countdown.\n"

int 
main(int argc, char * argv[])
{
	int waitsecs = 0;
	char * msg;
	
    if (argc < 3)
	{
        printf(1, "%s", USAGE_STR);
		exit();
	}
	
	waitsecs = atoi(argv[1]);
	msg = argv[2];
	
    shutdown(waitsecs, msg);
	
    exit(); // return 0;
}
