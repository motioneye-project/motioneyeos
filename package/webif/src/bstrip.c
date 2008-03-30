#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUF_SIZE 1024
#define READ_LEN 14

static int read_len = READ_LEN;
static char rbuf[32];
static char rbuflen = 0;

int do_gets(char *buf)
{
	int r = 0, c = 0;
	char *m;

	if (rbuflen > 0)
		memcpy(buf, rbuf, rbuflen);
	c += rbuflen;

	while ((c + read_len < BUF_SIZE) && ((r = read(0, &buf[c], read_len)) > 0)) {
		m = NULL;

		if ((m = memchr(&buf[c], '\n', r)) != NULL) {
			rbuflen = r - (m - &buf[c] + 1);
			if (rbuflen > 0)
				memcpy(rbuf, m + 1, rbuflen);
			c += m - &buf[c] + 1;
		} else {
			rbuflen = 0;
			c += r;
		}

		if ((c > 3) && (memcmp(&buf[c - 3], "---", 3) == 0))
			read_len = 1;

		if (m != NULL)
			return c;
	}

	return c;
}

int main(int argc, char **argv)
{
	char buf[BUF_SIZE];
	char buf1[BUF_SIZE];
	char *tmp;
	int len, r = 0, r1 = 0;

	if (argc != 2) {
		fprintf(stderr, "Syntax: %s (name|data <boundary>)\n", argv[0]);
		exit(1);
	}
	while (tmp = strchr(argv[1], '\r'))
		*tmp = 0;

	len = strlen(argv[1]);

	*buf = 0;
	while ((strncmp(buf, argv[1], len) != 0) &&
		(strncmp(buf + 2, argv[1], len) != 0)) {
		if (r > 0) {
			if (r1 > 0)
				write (1, buf1, r1);
			r1 = r;
			memcpy(buf1, buf, r);
		}
		if ((r = do_gets(buf)) <= 0)
			exit(1);
	}

	if (r1 > 2)
		write(1, buf1, r1 - 2);
}
