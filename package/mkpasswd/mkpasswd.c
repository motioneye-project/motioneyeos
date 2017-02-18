/*
 * Copyright (C) 2001-2008  Marco d'Itri
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/* for crypt, snprintf and strcasecmp */
#define _XOPEN_SOURCE
#define _BSD_SOURCE

/* System library */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "config.h"
#ifdef HAVE_GETOPT_LONG
#include <getopt.h>
#endif
#include <fcntl.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#ifdef HAVE_XCRYPT
#include <xcrypt.h>
#include <sys/stat.h>
#endif
#ifdef HAVE_LINUX_CRYPT_GENSALT
#define _OW_SOURCE
#include <crypt.h>
#endif
#ifdef HAVE_GETTIMEOFDAY
#include <sys/time.h>
#endif

/* Application-specific */
#include "utils.h"

/* Global variables */
#ifdef HAVE_GETOPT_LONG
static const struct option longopts[] = {
    {"method",		optional_argument,	NULL, 'm'},
    /* for backward compatibility with versions < 4.7.25 (< 20080321): */
    {"hash",		optional_argument,	NULL, 'H'},
    {"help",		no_argument,		NULL, 'h'},
    {"password-fd",	required_argument,	NULL, 'P'},
    {"stdin",		no_argument,		NULL, 's'},
    {"salt",		required_argument,	NULL, 'S'},
    {"rounds",		required_argument,	NULL, 'R'},
    {"version",		no_argument,		NULL, 'V'},
    {NULL,		0,			NULL, 0  }
};
#else
extern char *optarg;
extern int optind;
#endif

static const char valid_salts[] = "abcdefghijklmnopqrstuvwxyz"
"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789./";

struct crypt_method {
    const char *method;		/* short name used by the command line option */
    const char *prefix;		/* salt prefix */
    const unsigned int minlen;	/* minimum salt length */
    const unsigned int maxlen;	/* maximum salt length */
    const unsigned int rounds;	/* supports a variable number of rounds */
    const char *desc;		/* long description for the methods list */
};

static const struct crypt_method methods[] = {
    /* method		prefix	minlen,	maxlen	rounds description */
    { "des",		"",	2,	2,	0,
	N_("standard 56 bit DES-based crypt(3)") },
    { "md5",		"$1$",	8,	8,	0, "MD5" },
#if defined OpenBSD || defined FreeBSD || (defined __SVR4 && defined __sun)
    { "bf",		"$2a$", 22,	22,	1, "Blowfish" },
#endif
#if defined HAVE_LINUX_CRYPT_GENSALT
    { "bf",		"$2a$", 22,	22,	1, "Blowfish, system-specific on 8-bit chars" },
    /* algorithm 2y fixes CVE-2011-2483 */
    { "bfy",		"$2y$", 22,	22,	1, "Blowfish, correct handling of 8-bit chars" },
#endif
#if defined FreeBSD
    { "nt",		"$3$",  0,	0,	0, "NT-Hash" },
#endif
#if defined HAVE_SHA_CRYPT
    /* http://people.redhat.com/drepper/SHA-crypt.txt */
    { "sha-256",	"$5$",	8,	16,	1, "SHA-256" },
    { "sha-512",	"$6$",	8,	16,	1, "SHA-512" },
#endif
    /* http://www.crypticide.com/dropsafe/article/1389 */
    /*
     * Actually the maximum salt length is arbitrary, but Solaris by default
     * always uses 8 characters:
     * http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/ \
     *   usr/src/lib/crypt_modules/sunmd5/sunmd5.c#crypt_gensalt_impl
     */
#if defined __SVR4 && defined __sun
    { "sunmd5",		"$md5$", 8,	8,	1, "SunMD5" },
#endif
    { NULL,		NULL,	0,	0,	0, NULL }
};

void generate_salt(char *const buf, const unsigned int len);
void *get_random_bytes(const int len);
void display_help(int error);
void display_version(void);
void display_methods(void);

int main(int argc, char *argv[])
{
    int ch, i;
    int password_fd = -1;
    unsigned int salt_minlen = 0;
    unsigned int salt_maxlen = 0;
    unsigned int rounds_support = 0;
    const char *salt_prefix = NULL;
    const char *salt_arg = NULL;
    unsigned int rounds = 0;
    char *salt = NULL;
    char rounds_str[30];
    char *password = NULL;

#ifdef ENABLE_NLS
    setlocale(LC_ALL, "");
    bindtextdomain(NLS_CAT_NAME, LOCALEDIR);
    textdomain(NLS_CAT_NAME);
#endif

    /* prepend options from environment */
    argv = merge_args(getenv("MKPASSWD_OPTIONS"), argv, &argc);

    while ((ch = GETOPT_LONGISH(argc, argv, "hH:m:5P:R:sS:V", longopts, 0))
	    > 0) {
	switch (ch) {
	case '5':
	    optarg = (char *) "md5";
	    /* fall through */
	case 'm':
	case 'H':
	    if (!optarg || strcaseeq("help", optarg)) {
		display_methods();
		exit(0);
	    }
	    for (i = 0; methods[i].method != NULL; i++)
		if (strcaseeq(methods[i].method, optarg)) {
		    salt_prefix = methods[i].prefix;
		    salt_minlen = methods[i].minlen;
		    salt_maxlen = methods[i].maxlen;
		    rounds_support = methods[i].rounds;
		    break;
		}
	    if (!salt_prefix) {
		fprintf(stderr, _("Invalid method '%s'.\n"), optarg);
		exit(1);
	    }
	    break;
	case 'P':
	    {
		char *p;
		password_fd = strtol(optarg, &p, 10);
		if (p == NULL || *p != '\0' || password_fd < 0) {
		    fprintf(stderr, _("Invalid number '%s'.\n"), optarg);
		    exit(1);
		}
	    }
	    break;
	case 'R':
	    {
		char *p;
		rounds = strtol(optarg, &p, 10);
		if (p == NULL || *p != '\0' || rounds < 0) {
		    fprintf(stderr, _("Invalid number '%s'.\n"), optarg);
		    exit(1);
		}
	    }
	    break;
	case 's':
	    password_fd = 0;
	    break;
	case 'S':
	    salt_arg = optarg;
	    break;
	case 'V':
	    display_version();
	    exit(0);
	case 'h':
	    display_help(EXIT_SUCCESS);
	default:
	    fprintf(stderr, _("Try '%s --help' for more information.\n"),
		    argv[0]);
	    exit(1);
	}
    }
    argc -= optind;
    argv += optind;

    if (argc == 2 && !salt_arg) {
	password = argv[0];
	salt_arg = argv[1];
    } else if (argc == 1) {
	password = argv[0];
    } else if (argc == 0) {
    } else {
	display_help(EXIT_FAILURE);
    }

    /* default: DES password */
    if (!salt_prefix) {
	salt_minlen = methods[0].minlen;
	salt_maxlen = methods[0].maxlen;
	salt_prefix = methods[0].prefix;
    }

    if (streq(salt_prefix, "$2a$") || streq(salt_prefix, "$2y$")) {
	/* OpenBSD Blowfish and derivatives */
	if (rounds <= 5)
	    rounds = 5;
	/* actually for 2a/2y it is the logarithm of the number of rounds */
	snprintf(rounds_str, sizeof(rounds_str), "%02u$", rounds);
    } else if (rounds_support && rounds)
	snprintf(rounds_str, sizeof(rounds_str), "rounds=%u$", rounds);
    else
	rounds_str[0] = '\0';

    if (salt_arg) {
	unsigned int c = strlen(salt_arg);
	if (c < salt_minlen || c > salt_maxlen) {
	    if (salt_minlen == salt_maxlen)
		fprintf(stderr, ngettext(
			"Wrong salt length: %d byte when %d expected.\n",
			"Wrong salt length: %d bytes when %d expected.\n", c),
			c, salt_maxlen);
	    else
		fprintf(stderr, ngettext(
			"Wrong salt length: %d byte when %d <= n <= %d"
			" expected.\n",
			"Wrong salt length: %d bytes when %d <= n <= %d"
			" expected.\n", c),
			c, salt_minlen, salt_maxlen);
	    exit(1);
	}
	while (c-- > 0) {
	    if (strchr(valid_salts, salt_arg[c]) == NULL) {
		fprintf(stderr, _("Illegal salt character '%c'.\n"),
			salt_arg[c]);
		exit(1);
	    }
	}

	salt = NOFAIL(malloc(strlen(salt_prefix) + strlen(rounds_str)
		+ strlen(salt_arg) + 1));
	*salt = '\0';
	strcat(salt, salt_prefix);
	strcat(salt, rounds_str);
	strcat(salt, salt_arg);
    } else {
#ifdef HAVE_SOLARIS_CRYPT_GENSALT
#error "This code path is untested on Solaris. Please send a patch."
	salt = crypt_gensalt(salt_prefix, NULL);
	if (!salt)
		perror(stderr, "crypt_gensalt");
#elif defined HAVE_LINUX_CRYPT_GENSALT
	void *entropy = get_random_bytes(64);

	salt = crypt_gensalt(salt_prefix, rounds, entropy, 64);
	if (!salt) {
		fprintf(stderr, "crypt_gensalt failed.\n");
		exit(2);
	}
	free(entropy);
#else
	unsigned int salt_len = salt_maxlen;

	if (salt_minlen != salt_maxlen) { /* salt length can vary */
	    srand(time(NULL) + getpid());
	    salt_len = rand() % (salt_maxlen - salt_minlen + 1) + salt_minlen;
	}

	salt = NOFAIL(malloc(strlen(salt_prefix) + strlen(rounds_str)
		+ salt_len + 1));
	*salt = '\0';
	strcat(salt, salt_prefix);
	strcat(salt, rounds_str);
	generate_salt(salt + strlen(salt), salt_len);
#endif
    }

    if (password) {
    } else if (password_fd != -1) {
	FILE *fp;
	char *p;

	if (isatty(password_fd))
	    fprintf(stderr, _("Password: "));
	password = NOFAIL(malloc(128));
	fp = fdopen(password_fd, "r");
	if (!fp) {
	    perror("fdopen");
	    exit(2);
	}
	if (!fgets(password, 128, fp)) {
	    perror("fgets");
	    exit(2);
	}

	p = strpbrk(password, "\n\r");
	if (p)
	    *p = '\0';
    } else {
	password = getpass(_("Password: "));
	if (!password) {
	    perror("getpass");
	    exit(2);
	}
    }

    {
	const char *result;
	result = crypt(password, salt);
	/* xcrypt returns "*0" on errors */
	if (!result || result[0] == '*') {
	    fprintf(stderr, "crypt failed.\n");
	    exit(2);
	}
	/* yes, using strlen(salt_prefix) on salt. It's not
	 * documented whether crypt_gensalt may change the prefix */
	if (!strneq(result, salt, strlen(salt_prefix))) {
	    fprintf(stderr, _("Method not supported by crypt(3).\n"));
	    exit(2);
	}
	printf("%s\n", result);
    }

    exit(0);
}

#ifdef RANDOM_DEVICE
void* get_random_bytes(const int count)
{
    char *buf;
    int fd;

    buf = NOFAIL(malloc(count));
    fd = open(RANDOM_DEVICE, O_RDONLY);
    if (fd < 0) {
	perror("open(" RANDOM_DEVICE ")");
	exit(2);
    }
    if (read(fd, buf, count) != count) {
	if (count < 0)
	    perror("read(" RANDOM_DEVICE ")");
	else
	    fprintf(stderr, "Short read of %s.\n", RANDOM_DEVICE);
	exit(2);
    }
    close(fd);

    return buf;
}
#endif

#ifdef RANDOM_DEVICE

void generate_salt(char *const buf, const unsigned int len)
{
    unsigned int i;

    unsigned char *entropy = get_random_bytes(len * sizeof(unsigned char));
    for (i = 0; i < len; i++)
	buf[i] = valid_salts[entropy[i] % (sizeof valid_salts - 1)];
    buf[i] = '\0';
}

#else /* RANDOM_DEVICE */

void generate_salt(char *const buf, const unsigned int len)
{
    unsigned int i;

# ifdef HAVE_GETTIMEOFDAY
    struct timeval tv;

    gettimeofday(&tv, NULL);
    srand(tv.tv_sec ^ tv.tv_usec);

# else /* HAVE_GETTIMEOFDAY */
#  warning "This system lacks a strong enough random numbers generator!"

    /*
     * The possible values of time over one year are 31536000, which is
     * two orders of magnitude less than the allowed entropy range (2^32).
     */
    srand(time(NULL) + getpid());

# endif /* HAVE_GETTIMEOFDAY */

    for (i = 0; i < len; i++)
	buf[i] = valid_salts[rand() % (sizeof valid_salts - 1)];
    buf[i] = '\0';
}

#endif /* RANDOM_DEVICE */

void display_help(int error)
{
    fprintf((EXIT_SUCCESS == error) ? stdout : stderr,
	    _("Usage: mkpasswd [OPTIONS]... [PASSWORD [SALT]]\n"
	    "Crypts the PASSWORD using crypt(3).\n\n"));
    fprintf(stderr, _(
"      -m, --method=TYPE     select method TYPE\n"
"      -5                    like --method=md5\n"
"      -S, --salt=SALT       use the specified SALT\n"
"      -R, --rounds=NUMBER   use the specified NUMBER of rounds\n"
"      -P, --password-fd=NUM read the password from file descriptor NUM\n"
"                            instead of /dev/tty\n"
"      -s, --stdin           like --password-fd=0\n"
"      -h, --help            display this help and exit\n"
"      -V, --version         output version information and exit\n"
"\n"
"If PASSWORD is missing then it is asked interactively.\n"
"If no SALT is specified, a random one is generated.\n"
"If TYPE is 'help', available methods are printed.\n"
"\n"
"Report bugs to %s.\n"), "<md+whois@linux.it>");
    exit(error);
}

void display_version(void)
{
    printf("mkpasswd %s\n\n", VERSION);
    puts("Copyright (C) 2001-2008 Marco d'Itri\n"
"This is free software; see the source for copying conditions.  There is NO\n"
"warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.");
}

void display_methods(void)
{
    unsigned int i;

    printf(_("Available methods:\n"));
    for (i = 0; methods[i].method != NULL; i++)
	printf("%s\t%s\n", methods[i].method, methods[i].desc);
}

