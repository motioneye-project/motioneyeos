################################################################################
#
# smcroute
#
################################################################################

SMCROUTE_VERSION = 2.1.1
SMCROUTE_SOURCE = smcroute-$(SMCROUTE_VERSION).tar.xz
SMCROUTE_SITE = https://github.com/troglobit/smcroute/releases/download/$(SMCROUTE_VERSION)
SMCROUTE_LICENSE = GPL-2.0+
SMCROUTE_LICENSE_FILES = COPYING

SMCROUTE_CONF_OPTS = ac_cv_func_setpgrp_void=yes
#BUG:The package Makefile uses CC?= even though the package is autotools based
SMCROUTE_MAKE_ENV = $(TARGET_CONFIGURE_OPTS)

$(eval $(autotools-package))
