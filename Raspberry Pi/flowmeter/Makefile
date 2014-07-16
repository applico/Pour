CC = gcc

flow: flow.c -lpigpio -lrt -lpthread

.PHONY: clean
clean:
	rm -f *.o a.out core flow

.PHONY: all
all: clean main