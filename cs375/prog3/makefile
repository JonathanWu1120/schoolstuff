CC = g++
CFLAGS = -Wall -Wextra -pedantic

all: prog3

run: all
	./submission smallInput.txt smallOutputGreedy2.txt 1
	./submission smallInput.txt smallOutputBacktracking.txt 2
	./submission input.txt outputGreedy2.txt 1
	./submission input.txt outputBacktracking.txt 2
	./submission mediumInput.txt mediumOutputGreedy2.txt 1
	./submission mediumInput.txt mediumOutputBacktracking.txt 2
	./submission badGreedyInput.txt outputbadGreedy1.txt 0
	./submission badGreedyInput.txt outputbadGreedy2.txt 1
	./submission badImprovedGreedyInput.txt outputbadImprovedGreedy2.txt 1

prog3: item.o prog3.o STree.o
	$(CC) $(CFLAGS) prog3.o item.o STree.o -o submission

STree.o: STree.cpp
	$(CC) $(CFLAGS) -c STree.cpp -o STree.o

item.o: item.cpp
	$(CC) $(CFLAGS) -c item.cpp -o item.o

prog3.o: item.o prog3.cpp
	$(CC) $(CFLAGS) -c prog3.cpp -o prog3.o

clean:
	rm -f *o submission

cleanall:
	rm -f *o submission smallOutputGreedy2.txt smallOutputBacktrack.txt outputGreedy2.txt outputBacktrack.txt mediumOutputGreedy2.txt mediumOutputBacktrack.txt badGreedyOutputGreedy1.txt badGreedyOutputGreedy2.txt badImprovedGreedyOutputGreedy2.txt
