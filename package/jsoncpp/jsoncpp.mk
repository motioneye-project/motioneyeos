################################################################################
#
# jsoncpp
#
################################################################################

JSONCPP_VERSION = 1.9.2
JSONCPP_SITE = $(call github,open-source-parsers,jsoncpp,$(JSONCPP_VERSION))
JSONCPP_LICENSE = Public Domain or MIT
JSONCPP_LICENSE_FILES = LICENSE
JSONCPP_INSTALL_STAGING = YES
JSONCPP_CONF_OPTS = -Dtests=false

$(eval $(meson-package))
