#
# This Makefile is based on the one distributed with the soekris gpio drivers.
# It is modified to work within buildroot.
#

include $(LINUX_KCONFIG)

CFLAGS =-O2 -DMODULE -D__KERNEL__  -I$(LINUX_SOURCE_DIR)/include  -Wall 
TARGET := gpio

ifdef CONFIG_SMP
	CFLAGS +=-D__SMP__-DSMP
endif

all: gpio.o writelcd.o 

gpio.o: common.o 4501driver.o 4801driver.o
	$(LD) -r 4501driver.o 4801driver.o common.o  -o gpio.o 

4501gpio.o: common.o 4501driver.o 
	$(LD) -r 4501driver.o common.o  -o 4501gpio.o 

4501driver.o: 4501driver.c 4501driver.h 
	$(CC) $(CFLAGS) -c 4501driver.c -o 4501driver.o

4801gpio.o: common.o 4801driver.o 
	$(LD) -r 4801driver.o common.o  -o 4801gpio.o 

4801driver.o: 4801driver.c 4801driver.h 
	$(CC) $(CFLAGS) -c 4801driver.c -o 4801driver.o

writelcd.o: common_writelcd.o 4801driver.o  4501driver.o 
	$(LD) -r 4801driver.o  4501driver.o common_writelcd.o  -o writelcd.o 

common.o: common.c common.h
	$(CC) $(CFLAGS) -c common.c -o common.o

common_writelcd.o: common_writelcd.c common.h
	$(CC) $(CFLAGS) -c common_writelcd.c -o common_writelcd.o

clean:
	rm -f *.o *~ core

