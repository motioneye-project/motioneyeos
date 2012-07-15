/**
 * Buildroot wrapper for external toolchains. This simply executes the real
 * toolchain with a number of arguments (sysroot/arch/..) hardcoded,
 * to ensure the external toolchain uses the correct configuration.
 * The hardcoded path arguments are defined relative to the actual location
 * of the binary.
 *
 * (C) 2011 Peter Korsgaard <jacmet@sunsite.dk>
 * (C) 2011 Daniel Nyström <daniel.nystrom@timeterminal.se>
 * (C) 2012 Arnout Vandecappelle (Essensium/Mind) <arnout@mind.be>
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

static char path[PATH_MAX];
static char sysroot[PATH_MAX];

static char *predef_args[] = {
	path,
	"--sysroot", sysroot,
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

int main(int argc, char **argv)
{
	char **args, **cur;
	char *relbasedir, *absbasedir;
	char *progpath = argv[0];
	char *basename;
	int ret;

	/* Calculate the relative paths */
	basename = strrchr(progpath, '/');
	if (basename) {
		*basename = '\0';
		basename++;
		relbasedir = malloc(strlen(progpath) + 7);
		if (relbasedir == NULL) {
			perror(__FILE__ ": malloc");
			return 2;
		}
		sprintf(relbasedir, "%s/../..", argv[0]);
		absbasedir = realpath(relbasedir, NULL);
	} else {
		basename = progpath;
		absbasedir = realpath("../..", NULL);
	}
	if (absbasedir == NULL) {
		perror(__FILE__ ": realpath");
		return 2;
	}

	/* Fill in the relative paths */
#ifdef BR_CROSS_PATH_REL
	ret = snprintf(path, sizeof(path), "%s/" BR_CROSS_PATH_REL "/%s", absbasedir, basename);
#else /* BR_CROSS_PATH_ABS */
	ret = snprintf(path, sizeof(path), BR_CROSS_PATH_ABS "/%s", basename);
#endif
	if (ret >= sizeof(path)) {
		perror(__FILE__ ": overflow");
		return 3;
	}
	ret = snprintf(sysroot, sizeof(sysroot), "%s/" BR_SYSROOT, absbasedir);
	if (ret >= sizeof(sysroot)) {
		perror(__FILE__ ": overflow");
		return 3;
	}

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

	if (execv(path, args))
		perror(path);

	free(args);

	return 2;
}
