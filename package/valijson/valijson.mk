################################################################################
#
# valijson
#
################################################################################

VALIJSON_VERSION = v0.1
VALIJSON_SITE = $(call github,tristanpenman,valijson,$(VALIJSON_VERSION))
VALIJSON_LICENSE = BSD-2-Clause
VALIJSON_LICENSE_FILES = LICENSE
VALIJSON_INSTALL_STAGING = YES
VALIJSON_INSTALL_TARGET = NO
VALIJSON_DEPENDENCIES = boost
VALIJSON_CONF_OPTS = -DINSTALL_HEADERS=TRUE

$(eval $(cmake-package))
