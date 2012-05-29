
all: generic

generic: ramspeed.c fltmem.c fltmark.c intmem.c intmark.c
	$(CC) $(CFLAGS) $^ -o ramspeed

i386: ramspeed.c i386/*.s i386/cpuinfo/*.s
	$(CC) $(CFLAGS) -DI386_ASM $^ -o ramspeed

x86_64: ramspeed.c amd64/*.s
	$(CC) $(CFLAGS) -DAMD64_ASM $^ -o ramspeed

clean:
	rm -f *.o ramspeed
