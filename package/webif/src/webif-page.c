/*
 * Webif page translator
 *
 * Copyright (C) 2005 Felix Fietkau <nbd@openwrt.org>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <glob.h>
#include <ctype.h>
#ifdef NVRAM
#include <bcmnvram.h>
#endif

#define HASH_MAX	100
#define LINE_BUF	1024 /* max. buffer allocated for one line */
#define MAX_TR		32	 /* max. translations done on one line */
#define TR_START	"@TR<<"
#define TR_END		">>"

struct lstr {
	char *name;
	char *value;
	struct lstr *next;
};
typedef struct lstr lstr;

static lstr *ltable[HASH_MAX];
static char buf[LINE_BUF], buf2[LINE_BUF];

/* djb2 hash function */
static inline unsigned long hash(char *str)
{
	unsigned long hash = 5381;
	int c;

	while ((c = *str++))
		hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
	
	return hash;
}

static inline char *translate_lookup(char *str)
{
	char *name, *def, *p, *res = NULL;
	lstr *i;
	int h;
	
	def = name = str;
	if (((p = strchr(str, '|')) != NULL)
		|| ((p = strchr(str, '#')) != NULL)) {
		def = p + 1;
		*p = 0;
	}
	
	h = hash(name) % HASH_MAX;
	i = ltable[h];
	while ((res == NULL) && (i != NULL)) {
		if (strcmp(name, i->name) == 0)
			res = i->value;
		i = i->next;
	}
	
	if (res == NULL)
		res = def;
	
	return res;
}

static inline void add_line(char *name, char *value)
{
	int h = hash(name) % HASH_MAX;
	lstr *s = malloc(sizeof(lstr));
	lstr *p;

	s->name = strdup(name);
	s->value = strdup(value);
	s->next = NULL;
	
	if (ltable[h] == NULL)
		ltable[h] = s;
	else {
		for(p = ltable[h]; p->next != NULL; p = p->next);
		p->next = s;
	}
}

static char *translate_line(char *line)
{
	static char *tok[MAX_TR * 3];
	char *l, *p, *p2, *res;
	int len = 0, pos = 0, i;

	l = line;
	while (l != NULL) {
		if ((p = strstr(l, TR_START)) == NULL) {
			len += strlen((tok[pos++] = l));
			break;
		}

		p2 = strstr(p, TR_END);
		if (p2 == NULL)
			break;

		*p = 0;
		*p2 = 0;
		len += strlen((tok[pos++] = l));
		len += strlen((tok[pos++] = translate_lookup(p + strlen(TR_START))));

		l = p2;
		l += strlen(TR_END);
	}
	len++;
	
	if (len > LINE_BUF)
		p = malloc(len);
	else
		p = buf2;

	p[0] = 0;
	res = p;
	for (i = 0; i < pos; i++) {
		strcat(p, tok[i]);
		p += strlen(tok[i]);
	}

	return res;
}

/* load and parse language file */
static void load_lang(char *file)
{
	FILE *f;
	char *b, *name, *value;

	f = fopen(file, "r");
	while (!feof(f) && (fgets(buf, LINE_BUF - 1, f) != NULL)) {
		b = buf;
		while (isspace(*b))
			b++; /* skip leading spaces */
		if (!*b)
			continue;
		
		name = b;
		if ((b = strstr(name, "=>")) == NULL)
			continue; /* separator not found */

		value = b + 2;
		if (!*value)
			continue;
		
		*b = 0;
		for (b--; isspace(*b); b--)
			*b = 0; /* remove trailing spaces */
		
		while (isspace(*value))
			value++; /* skip leading spaces */

		for (b = value + strlen(value) - 1; isspace(*b); b--)
			*b = 0; /* remove trailing spaces */
		
		if (!*value)
			continue;

		add_line(name, value);
	}
}

int main (int argc, char **argv)
{
	FILE *f;
	int len, i, done;
	char line[LINE_BUF], *tmp, *arg;
	glob_t langfiles;
	char *lang = NULL;
	char *proc = "/usr/bin/haserl";

	memset(ltable, 0, HASH_MAX * sizeof(lstr *));
#ifdef NVRAM
	if ((lang = nvram_get("language")) != NULL) {
#else
	if ((f = fopen("/etc/config/webif", "r")) != NULL) {
		int n, i;
		
		while (!feof(f) && (lang == NULL)) {
			fgets(line, LINE_BUF - 1, f);
			
			if (strncasecmp(line, "lang", 4) != 0)
				goto nomatch;
			
			lang = line + 4;
			while (isspace(*lang))
				lang++;
			
			if (*lang != '=')
				goto nomatch;

			lang++;

			while (isspace(*lang))
				lang++;

			for (i = 0; isalpha(lang[i]) && (i < 32); i++);
			lang[i] = 0;
			continue;
nomatch:
			lang = NULL;
		}
		fclose(f);
#endif

		sprintf(buf, "/usr/lib/webif/lang/%s/*.txt", lang);
		i = glob(buf, GLOB_ERR | GLOB_MARK, NULL, &langfiles);
		if (i == GLOB_NOSPACE || i == GLOB_ABORTED || i == GLOB_NOMATCH) {
			// no language files found
		} else {
			for (i = 0; i < langfiles.gl_pathc; i++) {
				load_lang(langfiles.gl_pathv[i]);
			}
		}
	}

	/*
	 * command line options for this parser are stored in argv[1] only.
	 * filename to be processed is in argv[2]
	 */
	done = 0;
	i = 1;
	while (!done) {
		if (argv[1] == NULL) {
			done = 1;
		} else if (strncmp(argv[1], "-e", 2) == 0) {
			argv[1] = strchr(argv[1], ' ');
			argv[1]++;
			if (argv[1] != NULL) {
				arg = argv[1];
				if ((tmp = strchr(argv[1], ' ')) != NULL) {
					*tmp = 0;
					argv[1] = &tmp[1];
				} else {
					argv[1] = NULL;
					i++;
				}
				system(arg);
			}
		} else if (strncmp(argv[1], "-p", 2) == 0) {
			argv[1] = strchr(argv[1], ' ');
			argv[1]++;
			if (argv[1] != NULL) {
				arg = argv[1];
				if ((tmp = strchr(argv[1], ' ')) != NULL) {
					*tmp = 0;
					argv[1] = &tmp[1];
				} else {
					argv[1] = NULL;
					i++;
				}
				proc = strdup(arg);
			}
		} else {
			done = 1;
		}
	}

	strcpy(buf, proc);
	while (argv[i]) {
		sprintf(buf + strlen(buf), " %s", argv[i++]);
	}
	f = popen(buf, "r");
	
	while (!feof(f) && (fgets(buf, LINE_BUF - 1, f)) != NULL) {
		fprintf(stdout, "%s", translate_line(buf));
		fflush(stdout);
	}
	
	return 0;
}
