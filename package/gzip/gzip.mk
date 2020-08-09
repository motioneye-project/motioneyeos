################################################################################
#
# gzip
#
################################################################################

GZIP_VERSION = 1.10
GZIP_SOURCE = gzip-$(GZIP_VERSION).tar.xz
GZIP_SITE = $(BR2_GNU_MIRROR)/gzip
# Some other tools expect it to be in /bin
GZIP_CONF_OPTS = --exec-prefix=/
GZIP_LICENSE = GPL-3.0+
GZIP_LICENSE_FILES = COPYING
GZIP_CONF_ENV += gl_cv_func_fflush_stdin=yes
HOST_GZIP_CONF_ENV += gl_cv_func_fflush_stdin=yes
# configure substitutes $(SHELL) for the shell shebang in scripts like
# gzexe. Unfortunately, the same $(SHELL) variable will also be used by
# make to run its commands. Fortunately, /bin/sh is always a POSIX shell
# on both the target and host systems that we support. Even with this,
# the configure check is slightly broken and prints a bogus warning:
#  "using /bin/sh, even though it may have file descriptor bugs"
GZIP_CONF_ENV += ac_cv_path_shell=/bin/sh

$(eval $(autotools-package))
$(eval $(host-autotools-package))
