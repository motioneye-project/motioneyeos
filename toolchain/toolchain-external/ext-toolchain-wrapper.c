/**
 * Buildroot wrapper for external toolchains. This simply executes the real
 * toolchain with a number of arguments (sysroot/arch/..) hardcoded,
 * to ensure the external toolchain uses the correct configuration.
 *
 * (C) 2011 Peter Korsgaard <jacmet@sunsite.dk>
 *
 * This file is licensed under the terms of the GNU General Public License
 * version 2.  This program is licensed "as is" without any warranty of any
 * kind, whether express or implied.
 */

#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <unistd.h>

#define MAXARGS 1000

static char path[PATH_MAX] = BR_CROSS_PATH;

static char *args[MAXARGS] = {
	path,
	"--sysroot", BR_SYSROOT,
#ifdef BR_ARCH
	"-march=" BR_ARCH,
#endif /* BR_ARCH */
#ifdef BR_TUNE
	"-mtune=" BR_TUNE,
#endif /* BR_TUNE */
#ifdef BR_ABI
	"-mabi=" BR_ABI,
#endif
#ifdef BR_SOFTFLOAT
	"-msoft-float",
#endif /* BR_SOFTFLOAT */
#ifdef BR_VFPFLOAT
	"-mfpu=vfp",
#endif /* BR_VFPFLOAT */
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
	int i;

	for (i=0; args[i]; i++);

	if ((argc+i) >= MAXARGS) {
		fputs("Too many arguments\n", stderr);
		return 1;
	}

	/* forward args */
	memcpy(&args[i], &argv[1], sizeof(argv[0]) * (argc - 1));

	strcat(path, get_basename(argv[0]));

	if (execv(path, args))
		perror(path);

	return 2;
}
