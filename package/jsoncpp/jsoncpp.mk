################################################################################
#
# jsoncpp
#
################################################################################

JSONCPP_VERSION = 1.9.1
JSONCPP_SITE = $(call github,open-source-parsers,jsoncpp,$(JSONCPP_VERSION))
JSONCPP_LICENSE = Public Domain or MIT
JSONCPP_LICENSE_FILES = LICENSE
JSONCPP_INSTALL_STAGING = YES

$(eval $(meson-package))
