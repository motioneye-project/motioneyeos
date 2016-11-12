################################################################################
#
# jasper
#
################################################################################

JASPER_VERSION = 1.900.22
JASPER_SITE = http://www.ece.uvic.ca/~frodo/jasper/software
JASPER_INSTALL_STAGING = YES
JASPER_DEPENDENCIES = jpeg
JASPER_LICENSE = JasPer License Version 2.0
JASPER_LICENSE_FILES = LICENSE
JASPER_CONF_OPTS = --disable-strict

# Xtensa gcc is unable to generate correct code with -O0 enabled by
# --enable-debug. Allow package build but disable debug.
ifeq ($(BR2_xtensa)$(BR2_ENABLE_DEBUG),yy)
JASPER_CONF_OPTS += --disable-debug
endif

$(eval $(autotools-package))
