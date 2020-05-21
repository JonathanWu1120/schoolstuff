all: lab7

lab7.o: lab7.c
	gcc -lpthread -c lab7.c -o lab7.o
lab7: lab7.o
	gcc -lpthread lab7.o -o lab7

clean:
	rm -f *o lab7

run: all
	./lab7 10 1 2 3

