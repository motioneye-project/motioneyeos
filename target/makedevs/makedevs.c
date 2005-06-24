/* vi: set sw=4 ts=4: */
/*
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License version 2 as
 *  published by the Free Software Foundation.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <getopt.h>
#include <time.h>
#include <pwd.h>
#include <grp.h>
#include <unistd.h>
#include <ctype.h>
#include <errno.h>
#include <libgen.h>
#include <stdarg.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/sysmacros.h>     /* major() and minor() */


const char *bb_applet_name;

void bb_verror_msg(const char *s, va_list p)
{
	fflush(stdout);
	fprintf(stderr, "%s: ", bb_applet_name);
	vfprintf(stderr, s, p);
}

void bb_error_msg(const char *s, ...)
{
	va_list p;

	va_start(p, s);
	bb_verror_msg(s, p);
	va_end(p);
	putc('\n', stderr);
}

void bb_error_msg_and_die(const char *s, ...)
{
	va_list p;

	va_start(p, s);
	bb_verror_msg(s, p);
	va_end(p);
	putc('\n', stderr);
	exit(1);
}

void bb_vperror_msg(const char *s, va_list p)
{
	int err=errno;
	if(s == 0) s = "";
	bb_verror_msg(s, p);
	if (*s) s = ": ";
	fprintf(stderr, "%s%s\n", s, strerror(err));
}

void bb_perror_msg(const char *s, ...)
{
	va_list p;

	va_start(p, s);
	bb_vperror_msg(s, p);
	va_end(p);
}

void bb_perror_msg_and_die(const char *s, ...)
{
	va_list p;

	va_start(p, s);
	bb_vperror_msg(s, p);
	va_end(p);
	exit(1);
}

FILE *bb_xfopen(const char *path, const char *mode)
{
	FILE *fp;
	if ((fp = fopen(path, mode)) == NULL)
		bb_perror_msg_and_die("%s", path);
	return fp;
}

enum {
	FILEUTILS_PRESERVE_STATUS = 1,
	FILEUTILS_DEREFERENCE = 2,
	FILEUTILS_RECUR = 4,
	FILEUTILS_FORCE = 8,
	FILEUTILS_INTERACTIVE = 16
};
int bb_make_directory (char *path, long mode, int flags)
{
	mode_t mask;
	const char *fail_msg;
	char *s = path;
	char c;
	struct stat st;

	mask = umask(0);
	if (mode == -1) {
		umask(mask);
		mode = (S_IXUSR | S_IXGRP | S_IXOTH |
				S_IWUSR | S_IWGRP | S_IWOTH |
				S_IRUSR | S_IRGRP | S_IROTH) & ~mask;
	} else {
		umask(mask & ~0300);
	}

	do {
		c = 0;

		if (flags & FILEUTILS_RECUR) {	/* Get the parent. */
			/* Bypass leading non-'/'s and then subsequent '/'s. */
			while (*s) {
				if (*s == '/') {
					do {
						++s;
					} while (*s == '/');
					c = *s;		/* Save the current char */
					*s = 0;		/* and replace it with nul. */
					break;
				}
				++s;
			}
		}

		if (mkdir(path, 0777) < 0) {
			/* If we failed for any other reason than the directory
			 * already exists, output a diagnostic and return -1.*/
			if (errno != EEXIST
					|| !(flags & FILEUTILS_RECUR)
					|| (stat(path, &st) < 0 || !S_ISDIR(st.st_mode))) {
				fail_msg = "create";
				umask(mask);
				break;
			}
			/* Since the directory exists, don't attempt to change
			 * permissions if it was the full target.  Note that
			 * this is not an error conditon. */
			if (!c) {
				umask(mask);
				return 0;
			}
		}

		if (!c) {
			/* Done.  If necessary, updated perms on the newly
			 * created directory.  Failure to update here _is_
			 * an error.*/
			umask(mask);
			if ((mode != -1) && (chmod(path, mode) < 0)){
				fail_msg = "set permissions of";
				break;
			}
			return 0;
		}

		/* Remove any inserted nul from the path (recursive mode). */
		*s = c;

	} while (1);

	bb_perror_msg ("Cannot %s directory `%s'", fail_msg, path);
	return -1;
}

const char * const bb_msg_memory_exhausted = "memory exhausted";

void *xmalloc(size_t size)
{
	void *ptr = malloc(size);
	if (ptr == NULL && size != 0)
		bb_error_msg_and_die(bb_msg_memory_exhausted);
	return ptr;
}

void *xcalloc(size_t nmemb, size_t size)
{
	void *ptr = calloc(nmemb, size);
	if (ptr == NULL && nmemb != 0 && size != 0)
		bb_error_msg_and_die(bb_msg_memory_exhausted);
	return ptr;
}

void *xrealloc(void *ptr, size_t size)
{
	ptr = realloc(ptr, size);
	if (ptr == NULL && size != 0)
		bb_error_msg_and_die(bb_msg_memory_exhausted);
	return ptr;
}

char *private_get_line_from_file(FILE *file, int c)
{
#define GROWBY (80)		/* how large we will grow strings by */

	int ch;
	int idx = 0;
	char *linebuf = NULL;
	int linebufsz = 0;

	while ((ch = getc(file)) != EOF) {
		/* grow the line buffer as necessary */
		if (idx > linebufsz - 2) {
			linebuf = xrealloc(linebuf, linebufsz += GROWBY);
		}
		linebuf[idx++] = (char)ch;
		if (!ch) return linebuf;
		if (c<2 && ch == '\n') {
			if (c) {
				--idx;
			}
			break;
		}
	}
	if (linebuf) {
		if (ferror(file)) {
			free(linebuf);
			return NULL;
		}
		linebuf[idx] = 0;
	}
	return linebuf;
}

char *bb_get_chomped_line_from_file(FILE *file)
{
	return private_get_line_from_file(file, 1);
}

long my_getpwnam(const char *name)
{
	struct passwd *myuser;

	myuser  = getpwnam(name);
	if (myuser==NULL)
		bb_error_msg_and_die("unknown user name: %s", name);

	return myuser->pw_uid;
}

long my_getgrnam(const char *name)
{
	struct group *mygroup;

	mygroup  = getgrnam(name);
	if (mygroup==NULL)
		bb_error_msg_and_die("unknown group name: %s", name);

	return (mygroup->gr_gid);
}

unsigned long get_ug_id(const char *s, long (*my_getxxnam)(const char *))
{
	unsigned long r;
	char *p;

	r = strtoul(s, &p, 10);
	if (*p || (s == p)) {
		r = my_getxxnam(s);
	}

	return r;
}

char * last_char_is(const char *s, int c)
{
	char *sret = (char *)s;
	if (sret) {
		sret = strrchr(sret, c);
		if(sret != NULL && *(sret+1) != 0)
			sret = NULL;
	}
	return sret;
}

void bb_xasprintf(char **string_ptr, const char *format, ...)
{
	va_list p;
	int r;

	va_start(p, format);
	r = vasprintf(string_ptr, format, p);
	va_end(p);

	if (r < 0) {
		bb_perror_msg_and_die("bb_xasprintf");
	}
}

char *concat_path_file(const char *path, const char *filename)
{
	char *outbuf;
	char *lc;

	if (!path)
		path = "";
	lc = last_char_is(path, '/');
	while (*filename == '/')
		filename++;
	bb_xasprintf(&outbuf, "%s%s%s", path, (lc==NULL ? "/" : ""), filename);

	return outbuf;
}

void bb_show_usage(void)
{
	fprintf(stderr, "%s: [-d device_table] rootdir\n\n", bb_applet_name);
	fprintf(stderr, "Creates a batch of special files as specified in a device table.\n");
	fprintf(stderr, "Device table entries take the form of:\n");
	fprintf(stderr, "type mode user group major minor start increment count\n\n");
	fprintf(stderr, "Where name is the file name,  type can be one of:\n");
	fprintf(stderr, "      f       A regular file\n");
	fprintf(stderr, "      d       Directory\n");
	fprintf(stderr, "      c       Character special device file\n");
	fprintf(stderr, "      b       Block special device file\n");
	fprintf(stderr, "      p       Fifo (named pipe)\n");
	fprintf(stderr, "uid is the user id for the target file, gid is the group id for the\n");
	fprintf(stderr, "target file.  The rest of the entries (major, minor, etc) apply to\n");
	fprintf(stderr, "to device special files.  A '-' may be used for blank entries.\n\n");
	fprintf(stderr, "For example:\n");
	fprintf(stderr, "<name>    <type> <mode> <uid> <gid> <major> <minor> <start> <inc> <count>\n");
	fprintf(stderr, "/dev         d    755    0    0     -       -       -       -     -\n");
	fprintf(stderr, "/dev/console c    666    0    0     5       1       -       -     -\n");
	fprintf(stderr, "/dev/null    c    666    0    0     1       3       0       0     -\n");
	fprintf(stderr, "/dev/zero    c    666    0    0     1       5       0       0     -\n");
	fprintf(stderr, "/dev/hda     b    640    0    0     3       0       0       0     -\n");
	fprintf(stderr, "/dev/hda     b    640    0    0     3       1       1       1     15\n\n");
	fprintf(stderr, "Will Produce:\n");
	fprintf(stderr, "/dev\n");
	fprintf(stderr, "/dev/console\n");
	fprintf(stderr, "/dev/null\n");
	fprintf(stderr, "/dev/zero\n");
	fprintf(stderr, "/dev/hda\n");
	fprintf(stderr, "/dev/hda[0-15]\n");
	exit(1);
}

int main(int argc, char **argv)
{
	int opt;
	FILE *table = stdin;
	char *rootdir = NULL;
	char *line = NULL;
	int linenum = 0;
	int ret = EXIT_SUCCESS;

	bb_applet_name = basename(argv[0]);

	while ((opt = getopt(argc, argv, "d:")) != -1) {
		switch(opt) {
			case 'd':
				table = bb_xfopen((line=optarg), "r");
				break;
			default:
				bb_show_usage();
		}
	}

	if (optind >= argc || (rootdir=argv[optind])==NULL) {
		bb_error_msg_and_die("root directory not speficied");
	}

	if (chdir(rootdir) != 0) {
		bb_perror_msg_and_die("Couldnt chdir to %s", rootdir);
	}

	umask(0);

	printf("rootdir=%s\n", rootdir);
	if (line) {
		printf("table='%s'\n", line);
	} else {
		printf("table=<stdin>\n");
	}

	while ((line = bb_get_chomped_line_from_file(table))) {
		char type;
		unsigned int mode = 0755;
		unsigned int major = 0;
		unsigned int minor = 0;
		unsigned int count = 0;
		unsigned int increment = 0;
		unsigned int start = 0;
		char name[41];
		char user[41];
		char group[41];
		char *full_name;
		uid_t uid;
		gid_t gid;

		linenum++;

		if ((2 > sscanf(line, "%40s %c %o %40s %40s %u %u %u %u %u", name,
						&type, &mode, user, group, &major,
						&minor, &start, &increment, &count)) ||
				((major | minor | start | count | increment) > 255))
		{
			if (*line=='\0' || *line=='#' || isspace(*line))
				continue;
			bb_error_msg("line %d invalid: '%s'\n", linenum, line);
			ret = EXIT_FAILURE;
			continue;
		}
		if (name[0] == '#') {
			continue;
		}
		if (group) {
			gid = get_ug_id(group, my_getgrnam);
		} else {
			gid = getgid();
		}
		if (user) {
			uid = get_ug_id(user, my_getpwnam);
		} else {
			uid = getuid();
		}
		full_name = concat_path_file(rootdir, name);

		if (type == 'd') {
			bb_make_directory(full_name, mode | S_IFDIR, FILEUTILS_RECUR);
			if (chown(full_name, uid, gid) == -1) {
				bb_perror_msg("line %d: chown failed for %s", linenum, full_name);
				ret = EXIT_FAILURE;
				goto loop;
			}
		} else {
			dev_t rdev;

			if (type == 'p') {
				mode |= S_IFIFO;
			}
			else if (type == 'c') {
				mode |= S_IFCHR;
			}
			else if (type == 'b') {
				mode |= S_IFBLK;
			} else {
				bb_error_msg("line %d: Unsupported file type %c", linenum, type);
				ret = EXIT_FAILURE;
				goto loop;
			}

			if (count > 0) {
				int i;
				char *full_name_inc;

				full_name_inc = xmalloc(strlen(full_name) + 4);
				for (i = start; i < count; i++) {
					sprintf(full_name_inc, "%s%d", full_name, i);
					rdev = (major << 8) + minor + (i * increment - start);
					if (mknod(full_name_inc, mode, rdev) == -1) {
						bb_perror_msg("line %d: Couldnt create node %s", linenum, full_name_inc);
						ret = EXIT_FAILURE;
					}
					else if (chown(full_name_inc, uid, gid) == -1) {
						bb_perror_msg("line %d: chown failed for %s", linenum, full_name_inc);
						ret = EXIT_FAILURE;
					}
				}
				free(full_name_inc);
			} else {
				rdev = (major << 8) + minor;
				if (mknod(full_name, mode, rdev) == -1) {
					bb_perror_msg("line %d: Couldnt create node %s", linenum, full_name);
					ret = EXIT_FAILURE;
				}
				else if (chown(full_name, uid, gid) == -1) {
					bb_perror_msg("line %d: chown failed for %s", linenum, full_name);
					ret = EXIT_FAILURE;
				}
			}
		}
loop:
		free(line);
		free(full_name);
	}
	fclose(table);

	return 0;
}
