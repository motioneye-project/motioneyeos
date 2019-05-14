################################################################################
#
# findutils
#
################################################################################

FINDUTILS_VERSION = 4.6.0
FINDUTILS_SITE = $(BR2_GNU_MIRROR)/findutils
FINDUTILS_LICENSE = GPL-3.0+
FINDUTILS_LICENSE_FILES = COPYING
FINDUTILS_CONF_ENV = \
	gl_cv_func_stdin=yes \
	ac_cv_func_working_mktime=yes \
	gl_cv_func_wcwidth_works=yes
# 0001-mountlist-include-sysmacros-h-for-glibc.patch
FINDUTILS_AUTORECONF = YES

$(eval $(autotools-package))
