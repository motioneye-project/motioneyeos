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

$(eval $(autotools-package))
