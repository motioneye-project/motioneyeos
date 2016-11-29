################################################################################
#
# jasper
#
################################################################################

JASPER_VERSION = version-1.900.31
JASPER_SITE = $(call github,mdadams,jasper,$(JASPER_VERSION))
JASPER_INSTALL_STAGING = YES
JASPER_DEPENDENCIES = jpeg
JASPER_LICENSE = JasPer License Version 2.0
JASPER_LICENSE_FILES = LICENSE

# No configure script included. We need to generate it.
JASPER_AUTORECONF = YES

JASPER_CONF_OPTS = --disable-strict

# Xtensa gcc is unable to generate correct code with -O0 enabled by
# --enable-debug. Allow package build but disable debug.
ifeq ($(BR2_xtensa)$(BR2_ENABLE_DEBUG),yy)
JASPER_CONF_OPTS += --disable-debug
endif

$(eval $(autotools-package))
