CC = g++
CFLAGS = -Wall -Wextra -pedantic

all: prog4

run: all
	./submission smallInput.txt smallOutputDynamic.txt 3
	./submission input.txt outputDynamic.txt 3
	./submission mediumInput.txt mediumOutputDynamic.txt 3
	./submission badGreedyInput.txt outputbadDynamic.txt 3
	./submission badImprovedGreedyInput.txt outputbadImprovedDynamic.txt 3

prog4: item.o prog4.o STree.o
	$(CC) $(CFLAGS) prog4.o item.o STree.o -o submission

STree.o: STree.cpp
	$(CC) $(CFLAGS) -c STree.cpp -o STree.o

item.o: item.cpp
	$(CC) $(CFLAGS) -c item.cpp -o item.o

prog3.o: item.o prog4.cpp
	$(CC) $(CFLAGS) -c prog4.cpp -o prog4.o

clean:
	rm -f *o submission

cleanall:
	rm -f *o submission smallOutputGreedy2.txt smallOutputBacktrack.txt outputGreedy2.txt outputBacktrack.txt mediumOutputGreedy2.txt mediumOutputBacktrack.txt badGreedyOutputGreedy1.txt badGreedyOutputGreedy2.txt badImprovedGreedyOutputGreedy2.txt
