################################################################################
#
# findutils
#
################################################################################

FINDUTILS_VERSION = 4.7.0
FINDUTILS_SOURCE = findutils-$(FINDUTILS_VERSION).tar.xz
FINDUTILS_SITE = $(BR2_GNU_MIRROR)/findutils
FINDUTILS_LICENSE = GPL-3.0+
FINDUTILS_LICENSE_FILES = COPYING
FINDUTILS_CONF_ENV = \
	gl_cv_func_stdin=yes \
	ac_cv_func_working_mktime=yes \
	gl_cv_func_wcwidth_works=yes

$(eval $(autotools-package))
