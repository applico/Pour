CC = gcc
CFLAGS =  -std=c99 -I. -lbcm2835
DEPS = 
OBJ = Adafruit_DHT.o

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

Adafruit_DHT: $(OBJ)
	gcc -o $@ $^ $(CFLAGS)

.PHONY: clean
clean:
	rm -f *.o *~ a.out core Adafruit_DHT