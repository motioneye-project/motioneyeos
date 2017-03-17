################################################################################
#
# mtools
#
################################################################################

MTOOLS_VERSION = 4.0.18
MTOOLS_SOURCE = mtools-$(MTOOLS_VERSION).tar.bz2
MTOOLS_SITE = $(BR2_GNU_MIRROR)/mtools
MTOOLS_LICENSE = GPLv3+
MTOOLS_LICENSE_FILES = COPYING
MTOOLS_CONF_OPTS = --without-x
# info documentation not needed
MTOOLS_CONF_ENV = \
	ac_cv_func_setpgrp_void=yes \
	ac_cv_path_INSTALL_INFO=

HOST_MTOOLS_CONF_ENV = \
	ac_cv_path_INSTALL_INFO=

# link with iconv if enabled
ifeq ($(BR2_PACKAGE_LIBICONV),y)
MTOOLS_DEPENDENCIES += libiconv
MTOOLS_CONF_ENV += LIBS=-liconv
endif

# Package does not build in parallel due to improper make rules
MTOOLS_MAKE = $(MAKE1)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
