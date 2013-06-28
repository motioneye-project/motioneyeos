
all: generic

generic: ramsmp.c fltmem.c fltmark.c intmem.c intmark.c
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o ramsmp

i386: ramsmp.c i386/*.s i386/cpuinfo/*.s
	$(CC) $(CFLAGS) -DI386_ASM $(LDFLAGS) $^ -o ramsmp

x86_64: ramsmp.c amd64/*.s
	$(CC) $(CFLAGS) -DAMD64_ASM $(LDFLAGS) $^ -o ramsmp

clean:
	rm -f *.o ramsmp
