################################################################################
#
# valijson
#
################################################################################

VALIJSON_VERSION = 424b706f990a9eb96dfc19cc8e54f2cd6ce5e186
VALIJSON_SITE = $(call github,tristanpenman,valijson,$(VALIJSON_VERSION))
VALIJSON_LICENSE = BSD-2c
VALIJSON_LICENSE_FILES = LICENSE
VALIJSON_INSTALL_STAGING = YES
VALIJSON_INSTALL_TARGET = NO
VALIJSON_DEPENDENCIES = boost
VALIJSON_CONF_OPTS = -DINSTALL_HEADERS=TRUE

$(eval $(cmake-package))
