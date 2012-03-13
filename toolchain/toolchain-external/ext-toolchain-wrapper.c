/**
 * Buildroot wrapper for external toolchains. This simply executes the real
 * toolchain with a number of arguments (sysroot/arch/..) hardcoded,
 * to ensure the external toolchain uses the correct configuration.
 *
 * (C) 2011 Peter Korsgaard <jacmet@sunsite.dk>
 * (C) 2011 Daniel Nyström <daniel.nystrom@timeterminal.se>
 *
 * This file is licensed under the terms of the GNU General Public License
 * version 2.  This program is licensed "as is" without any warranty of any
 * kind, whether express or implied.
 */

#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <unistd.h>
#include <stdlib.h>

static char path[PATH_MAX] = BR_CROSS_PATH;

static char *predef_args[] = {
	path,
	"--sysroot", BR_SYSROOT,
#ifdef BR_ARCH
	"-march=" BR_ARCH,
#endif /* BR_ARCH */
#ifdef BR_TUNE
	"-mtune=" BR_TUNE,
#endif /* BR_TUNE */
#ifdef BR_CPU
	"-mcpu=" BR_CPU,
#endif
#ifdef BR_ABI
	"-mabi=" BR_ABI,
#endif
#ifdef BR_SOFTFLOAT
	"-msoft-float",
#endif /* BR_SOFTFLOAT */
#ifdef BR_VFPFLOAT
	"-mfpu=vfp",
#endif /* BR_VFPFLOAT */
#ifdef BR_64
	"-m64",
#endif
#ifdef BR_ADDITIONAL_CFLAGS
	BR_ADDITIONAL_CFLAGS
#endif
};

static const char *get_basename(const char *name)
{
	const char *base;

	base = strrchr(name, '/');
	if (base)
		base++;
	else
		base = name;

	return base;
}

int main(int argc, char **argv)
{
	char **args, **cur;

	cur = args = malloc(sizeof(predef_args) + (sizeof(char *) * argc));
	if (args == NULL) {
		perror(__FILE__ ": malloc");
		return 2;
	}

	/* start with predefined args */
	memcpy(cur, predef_args, sizeof(predef_args));
	cur += sizeof(predef_args) / sizeof(predef_args[0]);

	/* append forward args */
	memcpy(cur, &argv[1], sizeof(char *) * (argc - 1));
	cur += argc - 1;

	/* finish with NULL termination */
	*cur = NULL;

	strcat(path, get_basename(argv[0]));

	if (execv(path, args))
		perror(path);

	free(args);

	return 2;
}
