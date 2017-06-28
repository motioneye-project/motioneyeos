/**
 * Buildroot wrapper for toolchains. This simply executes the real toolchain
 * with a number of arguments (sysroot/arch/..) hardcoded, to ensure the
 * toolchain uses the correct configuration.
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

#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

#ifdef BR_CCACHE
static char ccache_path[PATH_MAX];
#endif
static char path[PATH_MAX];
static char sysroot[PATH_MAX];

/**
 * GCC errors out with certain combinations of arguments (examples are
 * -mfloat-abi={hard|soft} and -m{little|big}-endian), so we have to ensure
 * that we only pass the predefined one to the real compiler if the inverse
 * option isn't in the argument list.
 * This specifies the worst case number of extra arguments we might pass
 * Currently, we have:
 * 	-mfloat-abi=
 * 	-march=
 * 	-mcpu=
 */
#define EXCLUSIVE_ARGS	3

static char *predef_args[] = {
#ifdef BR_CCACHE
	ccache_path,
#endif
	path,
	"--sysroot", sysroot,
#ifdef BR_ABI
	"-mabi=" BR_ABI,
#endif
#ifdef BR_NAN
	"-mnan=" BR_NAN,
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
#ifdef BR_OMIT_LOCK_PREFIX
	"-Wa,-momit-lock-prefix=yes",
#endif
#ifdef BR_NO_FUSED_MADD
	"-mno-fused-madd",
#endif
#ifdef BR_BINFMT_FLAT
	"-Wl,-elf2flt",
#endif
#ifdef BR_MIPS_TARGET_LITTLE_ENDIAN
	"-EL",
#endif
#if defined(BR_MIPS_TARGET_BIG_ENDIAN) || defined(BR_ARC_TARGET_BIG_ENDIAN)
	"-EB",
#endif
#ifdef BR_ADDITIONAL_CFLAGS
	BR_ADDITIONAL_CFLAGS
#endif
};

/* A {string,length} tuple, to avoid computing strlen() on constants.
 *  - str must be a \0-terminated string
 *  - len does not account for the terminating '\0'
 */
struct str_len_s {
	const char *str;
	size_t     len;
};

/* Define a {string,length} tuple. Takes an unquoted constant string as
 * parameter. sizeof() on a string literal includes the terminating \0,
 * but we don't want to count it.
 */
#define STR_LEN(s) { #s, sizeof(#s)-1 }

/* List of paths considered unsafe for cross-compilation.
 *
 * An unsafe path is one that points to a directory with libraries or
 * headers for the build machine, which are not suitable for the target.
 */
static const struct str_len_s unsafe_paths[] = {
	STR_LEN(/lib),
	STR_LEN(/usr/include),
	STR_LEN(/usr/lib),
	STR_LEN(/usr/local/include),
	STR_LEN(/usr/local/lib),
	{ NULL, 0 },
};

/* Unsafe options are options that specify a potentialy unsafe path,
 * that will be checked by check_unsafe_path(), below.
 */
static const struct str_len_s unsafe_opts[] = {
	STR_LEN(-I),
	STR_LEN(-idirafter),
	STR_LEN(-iquote),
	STR_LEN(-isystem),
	STR_LEN(-L),
	{ NULL, 0 },
};

/* Check if path is unsafe for cross-compilation. Unsafe paths are those
 * pointing to the standard native include or library paths.
 *
 * We print the arguments leading to the failure. For some options, gcc
 * accepts the path to be concatenated to the argument (e.g. -I/foo/bar)
 * or separated (e.g. -I /foo/bar). In the first case, we need only print
 * the argument as it already contains the path (arg_has_path), while in
 * the second case we need to print both (!arg_has_path).
 *
 * If paranoid, exit in error instead of just printing a warning.
 */
static void check_unsafe_path(const char *arg,
			      const char *path,
			      int paranoid,
			      int arg_has_path)
{
	const struct str_len_s *p;

	for (p=unsafe_paths; p->str; p++) {
		if (strncmp(path, p->str, p->len))
			continue;
		fprintf(stderr,
			"%s: %s: unsafe header/library path used in cross-compilation: '%s%s%s'\n",
			program_invocation_short_name,
			paranoid ? "ERROR" : "WARNING",
			arg,
			arg_has_path ? "" : "' '", /* close single-quote, space, open single-quote */
			arg_has_path ? "" : path); /* so that arg and path are properly quoted. */
		if (paranoid)
			exit(1);
	}
}

int main(int argc, char **argv)
{
	char **args, **cur, **exec_args;
	char *relbasedir, *absbasedir;
	char *progpath = argv[0];
	char *basename;
	char *env_debug;
	char *paranoid_wrapper;
	int paranoid;
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
		sprintf(relbasedir, "%s/..", argv[0]);
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
				if (++count == 2)
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
	ret = snprintf(path, sizeof(path), "%s/" BR_CROSS_PATH_REL "/%s" BR_CROSS_PATH_SUFFIX, absbasedir, basename);
#elif defined(BR_CROSS_PATH_ABS)
	ret = snprintf(path, sizeof(path), BR_CROSS_PATH_ABS "/%s" BR_CROSS_PATH_SUFFIX, basename);
#else
	ret = snprintf(path, sizeof(path), "%s/bin/%s" BR_CROSS_PATH_SUFFIX, absbasedir, basename);
#endif
	if (ret >= sizeof(path)) {
		perror(__FILE__ ": overflow");
		return 3;
	}
#ifdef BR_CCACHE
	ret = snprintf(ccache_path, sizeof(ccache_path), "%s/bin/ccache", absbasedir);
	if (ret >= sizeof(ccache_path)) {
		perror(__FILE__ ": overflow");
		return 3;
	}
#endif
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

#ifdef BR_FP32_MODE
	/* add fp32 mode if soft-float is not args or hard-float overrides soft-float */
	int add_fp32_mode = 1;
	for (i = 1; i < argc; i++) {
		if (!strcmp(argv[i], "-msoft-float"))
			add_fp32_mode = 0;
		else if (!strcmp(argv[i], "-mhard-float"))
			add_fp32_mode = 1;
	}

	if (add_fp32_mode == 1)
		*cur++ = "-mfp" BR_FP32_MODE;
#endif

#if defined(BR_ARCH) || \
    defined(BR_CPU)
	/* Add our -march/cpu flags, but only if none of
	 * -march/mtune/mcpu are already specified on the commandline
	 */
	for (i = 1; i < argc; i++) {
		if (!strncmp(argv[i], "-march=", strlen("-march=")) ||
		    !strncmp(argv[i], "-mtune=", strlen("-mtune=")) ||
		    !strncmp(argv[i], "-mcpu=",  strlen("-mcpu=" )))
			break;
	}
	if (i == argc) {
#ifdef BR_ARCH
		*cur++ = "-march=" BR_ARCH;
#endif
#ifdef BR_CPU
		*cur++ = "-mcpu=" BR_CPU;
#endif
	}
#endif /* ARCH || CPU */

	paranoid_wrapper = getenv("BR_COMPILER_PARANOID_UNSAFE_PATH");
	if (paranoid_wrapper && strlen(paranoid_wrapper) > 0)
		paranoid = 1;
	else
		paranoid = 0;

	/* Check for unsafe library and header paths */
	for (i = 1; i < argc; i++) {
		const struct str_len_s *opt;
		for (opt=unsafe_opts; opt->str; opt++ ) {
			/* Skip any non-unsafe option. */
			if (strncmp(argv[i], opt->str, opt->len))
				continue;

			/* Handle both cases:
			 *  - path is a separate argument,
			 *  - path is concatenated with option.
			 */
			if (argv[i][opt->len] == '\0') {
				i++;
				if (i == argc)
					break;
				check_unsafe_path(argv[i-1], argv[i], paranoid, 0);
			} else
				check_unsafe_path(argv[i], argv[i] + opt->len, paranoid, 1);
		}
	}

	/* append forward args */
	memcpy(cur, &argv[1], sizeof(char *) * (argc - 1));
	cur += argc - 1;

	/* finish with NULL termination */
	*cur = NULL;

	exec_args = args;
#ifdef BR_CCACHE
	if (getenv("BR_NO_CCACHE"))
		/* Skip the ccache call */
		exec_args++;
#endif

	/* Debug the wrapper to see actual arguments passed to
	 * the compiler:
	 * unset, empty, or 0: do not trace
	 * set to 1          : trace all arguments on a single line
	 * set to 2          : trace one argument per line
	 */
	if ((env_debug = getenv("BR2_DEBUG_WRAPPER"))) {
		debug = atoi(env_debug);
		if (debug > 0) {
			fprintf(stderr, "Toolchain wrapper executing:");
#ifdef BR_CCACHE_HASH
			fprintf(stderr, "%sCCACHE_COMPILERCHECK='string:" BR_CCACHE_HASH "'",
				(debug == 2) ? "\n    " : " ");
#endif
#ifdef BR_CCACHE_BASEDIR
			fprintf(stderr, "%sCCACHE_BASEDIR='" BR_CCACHE_BASEDIR "'",
				(debug == 2) ? "\n    " : " ");
#endif
			for (i = 0; exec_args[i]; i++)
				fprintf(stderr, "%s'%s'",
					(debug == 2) ? "\n    " : " ", exec_args[i]);
			fprintf(stderr, "\n");
		}
	}

#ifdef BR_CCACHE_HASH
	/* Allow compilercheck to be overridden through the environment */
	if (setenv("CCACHE_COMPILERCHECK", "string:" BR_CCACHE_HASH, 0)) {
		perror(__FILE__ ": Failed to set CCACHE_COMPILERCHECK");
		return 3;
	}
#endif
#ifdef BR_CCACHE_BASEDIR
	/* Allow compilercheck to be overridden through the environment */
	if (setenv("CCACHE_BASEDIR", BR_CCACHE_BASEDIR, 0)) {
		perror(__FILE__ ": Failed to set CCACHE_BASEDIR");
		return 3;
	}
#endif

	if (execv(exec_args[0], exec_args))
		perror(path);

	free(args);

	return 2;
}
