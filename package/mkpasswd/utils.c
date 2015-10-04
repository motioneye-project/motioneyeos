/*
 * Copyright 1999-2008 by Marco d'Itri <md@linux.it>.
 *
 * do_nofail and merge_args come from the module-init-tools package.
 * Copyright 2001 by Rusty Russell.
 * Copyright 2002, 2003 by Rusty Russell, IBM Corporation.
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
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

/* for strdup */
#define _XOPEN_SOURCE 500

/* System library */
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>

/* Application-specific */
#include "utils.h"

void *do_nofail(void *ptr, const char *file, const int line)
{
    if (ptr)
	return ptr;

    err_quit("Memory allocation failure at %s:%d.", file, line);
}

/* Prepend options from a string. */
char **merge_args(char *args, char *argv[], int *argc)
{
    char *arg, *argstring;
    char **newargs = NULL;
    unsigned int i, num_env = 0;

    if (!args)
	return argv;

    argstring = NOFAIL(strdup(args));
    for (arg = strtok(argstring, " "); arg; arg = strtok(NULL, " ")) {
	num_env++;
	newargs = NOFAIL(realloc(newargs,
		    sizeof(newargs[0]) * (num_env + *argc + 1)));
	newargs[num_env] = arg;
    }

    if (!newargs)
	return argv;

    /* Append commandline args */
    newargs[0] = argv[0];
    for (i = 1; i <= *argc; i++)
	newargs[num_env + i] = argv[i];

    *argc += num_env;
    return newargs;
}

/* Error routines */
void err_sys(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, ": %s\n", strerror(errno));
    va_end(ap);
    exit(2);
}

void err_quit(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    fputs("\n", stderr);
    va_end(ap);
    exit(2);
}

