################################################################################
#
# m4
#
################################################################################

M4_VERSION = 1.4.17
M4_SOURCE = m4-$(M4_VERSION).tar.xz
M4_SITE = $(BR2_GNU_MIRROR)/m4
M4_LICENSE = GPLv3+
M4_LICENSE_FILES = COPYING
M4_CONF_ENV = gl_cv_func_gettimeofday_clobber=no

ifneq ($(BR2_USE_WCHAR),y)
M4_CONF_ENV += gt_cv_c_wchar_t=no gl_cv_absolute_wchar_h=__fpending.h
endif

HOST_M4_CONF_OPT = --disable-static

$(eval $(autotools-package))
$(eval $(host-autotools-package))
