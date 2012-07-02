#############################################################
#
# findutils
#
#############################################################

FINDUTILS_VERSION = 4.4.2
FINDUTILS_SITE = $(BR2_GNU_MIRROR)/findutils
FINDUTILS_CONF_ENV = gl_cv_func_stdin=yes \
			gl_cv_func_wcwidth_works=yes

$(eval $(autotools-package))
