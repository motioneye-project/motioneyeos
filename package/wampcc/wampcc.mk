################################################################################
#
# wampcc
#
################################################################################

WAMPCC_VERSION = v1.6
WAMPCC_SITE = $(call github,darrenjs,wampcc,$(WAMPCC_VERSION))
WAMPCC_DEPENDENCIES = host-pkgconf libuv jansson openssl
WAMPCC_INSTALL_STAGING = YES
WAMPCC_LICENSE = MIT
WAMPCC_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
