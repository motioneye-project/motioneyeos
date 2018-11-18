################################################################################
#
# time
#
################################################################################

TIME_VERSION = 1.9
TIME_SITE = $(BR2_GNU_MIRROR)/time
TIME_CONF_ENV = ac_cv_func_wait3_rusage=yes
TIME_LICENSE = GPL-3.0+
TIME_LICENSE_FILES = COPYING

$(eval $(autotools-package))
