################################################################################
#
# gzip
#
################################################################################

GZIP_VERSION = 1.8
GZIP_SOURCE = gzip-$(GZIP_VERSION).tar.xz
GZIP_SITE = $(BR2_GNU_MIRROR)/gzip
# Some other tools expect it to be in /bin
GZIP_CONF_OPTS = --exec-prefix=/
# Prefer full gzip over potentially lightweight/slower from busybox
GZIP_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
GZIP_LICENSE = GPLv3+
GZIP_LICENSE_FILES = COPYING
GZIP_CONF_ENV += gl_cv_func_fflush_stdin=yes

$(eval $(autotools-package))
