

all: spi_test

spi_test: spi_test.o
	 gcc -o spi_test spi_test.o -lwiringPi -lpigpiod_if2

spi_test.o: spi_test.c
	 gcc -c spi_test.c

clean:
	 rm spi_test.o spi_test
