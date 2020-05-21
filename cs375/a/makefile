CC = g++
CFLAGS = -Wall -Wextra -pedantic

all: prog2

prog2: heap.o prog2.o
	$(CC) $(CFLAGS) prog2.o heap.o -o submission

heap.o: heap.cpp 
	$(CC) $(CFLAGS) -c heap.cpp -o heap.o

prog2.o: heap.o prog2.cpp
	$(CC) -c $(CFLAGS) prog2.cpp -o prog2.o

run: all
	./submission

clean:
	rm -f *o submission
