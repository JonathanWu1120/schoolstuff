CC = gcc
CFLAGS = -Wall -DBSD -DNDEBUG

all: flip

flip: flip.o getopt.o
	$(CC) $(CFLAGS) flip.o getopt.o -o flip

flip.o: flip.c flip.h
	$(CC) $(CFLAGS) -c flip.c -o flip.o

getopt.o: getopt.c flip.h
	$(CC) $(CFLAGS) -c getopt.c -o getopt.o

clean:
	rm -f *o flip flip.man

flip.man:
	nroff -man flip.1 > flip.man

