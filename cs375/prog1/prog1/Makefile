CC = g++
CFLAGS = -Wall -Wextra 

all: prog1

prog1.o: prog1.cpp
	$(CC) $(CFLAGS) -c prog1.cpp -o prog1.o

prog1: prog1.o
	$(CC) $(CFLAGS)  prog1.o -o program1


clean:
	rm -f *o program1

