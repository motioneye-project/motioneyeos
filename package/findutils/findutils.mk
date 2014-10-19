################################################################################
#
# findutils
#
################################################################################

FINDUTILS_VERSION = 4.4.2
FINDUTILS_SITE = $(BR2_GNU_MIRROR)/findutils
FINDUTILS_LICENSE = GPLv3+
FINDUTILS_LICENSE_FILES = COPYING
FINDUTILS_CONF_ENV = gl_cv_func_stdin=yes \
			ac_cv_func_working_mktime=yes \
			gl_cv_func_wcwidth_works=yes

$(eval $(autotools-package))
