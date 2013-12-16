################################################################################
#
# smcroute
#
################################################################################

SMCROUTE_VERSION = 1.99.2
SMCROUTE_SITE = $(call github,troglobit,smcroute,$(SMCROUTE_VERSION))
SMCROUTE_LICENSE = GPLv2+
SMCROUTE_LICENSE_FILES = COPYING

SMCROUTE_CONF_OPT = ac_cv_func_setpgrp_void=yes
#BUG:The package Makefile uses CC?= even though the package is autotools based
SMCROUTE_MAKE_ENV = $(TARGET_CONFIGURE_OPTS)

$(eval $(autotools-package))
