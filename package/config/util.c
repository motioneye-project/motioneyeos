/*
 * Copyright (C) 2002-2005 Roman Zippel <zippel@linux-m68k.org>
 * Copyright (C) 2002-2005 Sam Ravnborg <sam@ravnborg.org>
 *
 * Released under the terms of the GNU GPL v2.0.
 */

#include <string.h>
#include "lkc.h"

/* file already present in list? If not add it */
struct file *file_lookup(const char *name)
{
	struct file *file;

	for (file = file_list; file; file = file->next) {
		if (!strcmp(name, file->name))
			return file;
	}

	file = malloc(sizeof(*file));
	memset(file, 0, sizeof(*file));
	file->name = strdup(name);
	file->next = file_list;
	file_list = file;
	return file;
}

static char* br2_symbol_printer(const char * const in)
{
	ssize_t i, j, len = strlen(in);
	char *ret;
	if (len < 1)
		return NULL;
	ret = malloc(len);
	if (!ret) {
		printf("Out of memory!");
		exit(1);
	}
	memset(ret, 0, len);
	i = j = 0;
	if (strncmp("BR2_", in, 4) == 0)
		i += 4;
	if (strncmp("PACKAGE_", in + i, 8) == 0)
		i += 8;
	else if (strncmp("TARGET_", in + i, 7) == 0)
		i += 7;
	while (i <= len)
		ret[j++] = tolower(in[i++]);
	return ret;
}

/* write dependencies of the infividual config-symbols */
static int write_make_deps(const char *name)
{
	struct menu *menu;
	struct symbol *sym;
	struct property *prop, *p;
	unsigned done;
	const char * const name_tmp = "..make.deps.tmp";
	FILE *out;
	if (!name)
		name = ".auto.deps";
	out = fopen(name_tmp, "w");
	if (!out)
		return 1;
	fprintf(out, "# ATTENTION! This does not handle 'depends', just 'select'! \n"
		"# See package/config/util.c write_make_deps()\n#\n");
	menu = &rootmenu;//rootmenu.list;
	while (menu) {
		sym = menu->sym;
		if (!sym) {
			if (!menu_is_visible(menu))
				goto next;
		} else if (!(sym->flags & SYMBOL_CHOICE)) {
			sym_calc_value(sym);
			if (sym->type == S_BOOLEAN
			    && sym_get_tristate_value(sym) != no) {
			    done = 0;
			    for_all_prompts(sym, prop) {
			        struct expr *e;
//printf("\nname=%s\n", sym->name);
			        for_all_properties(sym, p, P_SELECT) {
				    e = p->expr;
				    if (e && e->left.sym->name) {
				        if (!done) {
					    fprintf(out, "%s:", br2_symbol_printer(sym->name));
					    done = 1;
					}
//printf("SELECTS %s\n",e->left.sym->name);
					fprintf(out, " %s",br2_symbol_printer(e->left.sym->name));
				    }
				}
				if (done)
				    fprintf(out, "\n");
#if 0
				e = sym->rev_dep.expr;
				if (e && e->type == E_SYMBOL
					&& e->left.sym->name) {
				    fprintf(out, "%s: %s", br2_symbol_printer(e->left.sym->name),
						br2_symbol_printer(sym->name));
printf("%s is Selected BY: %s", sym->name, e->left.sym->name);
				}
#endif
			    }
			}
		}
next:
		if (menu->list) {
			menu = menu->list;
			continue;
		}
		if (menu->next)
			menu = menu->next;
		else while ((menu = menu->parent)) {
			if (menu->next) {
				menu = menu->next;
				break;
			}
		}
	}
	fclose(out);
	rename(name_tmp, name);
	printf(_("#\n"
		 "# make dependencies written to %s\n"
		 "# ATTENTION buildroot devels!\n"
		 "# See top of this file before playing with this auto-preprequisites!\n"
		 "#\n"), name);
	return 0;
}

/* write a dependency file as used by kbuild to track dependencies */
int file_write_dep(const char *name)
{
	struct file *file;
	FILE *out;

	if (!name)
		name = ".kconfig.d";
	out = fopen("..config.tmp", "w");
	if (!out)
		return 1;
	fprintf(out, "deps_config := \\\n");
	for (file = file_list; file; file = file->next) {
		if (file->next)
			fprintf(out, "\t%s \\\n", file->name);
		else
			fprintf(out, "\t%s\n", file->name);
	}
	fprintf(out, "\n$(BR2_DEPENDS_DIR)/config/auto.conf: \\\n"
		     "\t$(deps_config)\n\n"
		     "$(deps_config): ;\n");
	fclose(out);
	rename("..config.tmp", name);

	return write_make_deps(NULL);
}


/* Allocate initial growable sting */
struct gstr str_new(void)
{
	struct gstr gs;
	gs.s = malloc(sizeof(char) * 64);
	gs.len = 16;
	strcpy(gs.s, "\0");
	return gs;
}

/* Allocate and assign growable string */
struct gstr str_assign(const char *s)
{
	struct gstr gs;
	gs.s = strdup(s);
	gs.len = strlen(s) + 1;
	return gs;
}

/* Free storage for growable string */
void str_free(struct gstr *gs)
{
	if (gs->s)
		free(gs->s);
	gs->s = NULL;
	gs->len = 0;
}

/* Append to growable string */
void str_append(struct gstr *gs, const char *s)
{
	size_t l = strlen(gs->s) + strlen(s) + 1;
	if (l > gs->len) {
		gs->s   = realloc(gs->s, l);
		gs->len = l;
	}
	strcat(gs->s, s);
}

/* Append printf formatted string to growable string */
void str_printf(struct gstr *gs, const char *fmt, ...)
{
	va_list ap;
	char s[10000]; /* big enough... */
	va_start(ap, fmt);
	vsnprintf(s, sizeof(s), fmt, ap);
	str_append(gs, s);
	va_end(ap);
}

/* Retrieve value of growable string */
const char *str_get(struct gstr *gs)
{
	return gs->s;
}

