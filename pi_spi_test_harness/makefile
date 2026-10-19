

all: spi_test

spi_test: spi_test.o
	 gcc -o spi_test spi_test.o -lpigpiod_if2 -pthread

spi_test.o: spi_test.c
	 gcc -c spi_test.c

clean:
	 rm spi_test.o spi_test
