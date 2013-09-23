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
 * (C) 2013 Spenser Gilliland <spenser@gillilanding.com>
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

/**
 * GCC errors out with certain combinations of arguments (examples are
 * -mabi-float={hard|soft} and -m{little|big}-endian), so we have to ensure
 * that we only pass the predefined one to the real compiler if the inverse
 * option isn't in the argument list.
 * This specifies the worst case number of extra arguments we might pass
 */
#define EXCLUSIVE_ARGS	1

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
#ifdef BR_FPU
	"-mfpu=" BR_FPU,
#endif
#ifdef BR_SOFTFLOAT
	"-msoft-float",
#endif /* BR_SOFTFLOAT */
#ifdef BR_MODE
	"-m" BR_MODE,
#endif
#ifdef BR_64
	"-m64",
#endif
#ifdef BR_BINFMT_FLAT
	"-Wl,-elf2flt",
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
	char *env_debug;
	int ret, i, count = 0, debug;

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
		absbasedir = malloc(PATH_MAX + 1);
		ret = readlink("/proc/self/exe", absbasedir, PATH_MAX);
		if (ret < 0) {
			perror(__FILE__ ": readlink");
			return 2;
		}
		absbasedir[ret] = '\0';
		for (i = ret; i > 0; i--) {
			if (absbasedir[i] == '/') {
				absbasedir[i] = '\0';
				if (++count == 3)
					break;
			}
		}
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

	cur = args = malloc(sizeof(predef_args) +
			    (sizeof(char *) * (argc + EXCLUSIVE_ARGS)));
	if (args == NULL) {
		perror(__FILE__ ": malloc");
		return 2;
	}

	/* start with predefined args */
	memcpy(cur, predef_args, sizeof(predef_args));
	cur += sizeof(predef_args) / sizeof(predef_args[0]);

#ifdef BR_FLOAT_ABI
	/* add float abi if not overridden in args */
	for (i = 1; i < argc; i++) {
		if (!strncmp(argv[i], "-mfloat-abi=", strlen("-mfloat-abi=")) ||
		    !strcmp(argv[i], "-msoft-float") ||
		    !strcmp(argv[i], "-mhard-float"))
			break;
	}

	if (i == argc)
		*cur++ = "-mfloat-abi=" BR_FLOAT_ABI;
#endif

	/* append forward args */
	memcpy(cur, &argv[1], sizeof(char *) * (argc - 1));
	cur += argc - 1;

	/* finish with NULL termination */
	*cur = NULL;

	/* Debug the wrapper to see actual arguments passed to
	 * the compiler:
	 * unset, empty, or 0: do not trace
	 * set to 1          : trace all arguments on a single line
	 * set to 2          : trace one argument per line
	 */
	if ((env_debug = getenv("BR_DEBUG_WRAPPER"))) {
		debug = atoi(env_debug);
		if (debug > 0) {
			fprintf(stderr, "Toolchain wrapper executing:");
			for (i = 0; args[i]; i++)
				fprintf(stderr, "%s'%s'",
					(debug == 2) ? "\n    " : " ", args[i]);
			fprintf(stderr, "\n");
		}
	}

	if (execv(path, args))
		perror(path);

	free(args);

	return 2;
}
