################################################################################
#
# valijson
#
################################################################################

VALIJSON_VERSION = 0.2
VALIJSON_SITE = $(call github,tristanpenman,valijson,v$(VALIJSON_VERSION))
VALIJSON_LICENSE = BSD-2-Clause
VALIJSON_LICENSE_FILES = LICENSE
VALIJSON_INSTALL_STAGING = YES
VALIJSON_INSTALL_TARGET = NO
VALIJSON_DEPENDENCIES = boost
VALIJSON_CONF_OPTS = -Dvalijson_INSTALL_HEADERS=TRUE -Dvalijson_BUILD_TESTS=FALSE

$(eval $(cmake-package))
