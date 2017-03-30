################################################################################
#
# tinyxml2
#
################################################################################

TINYXML2_VERSION = 3.0.0
TINYXML2_SITE = $(call github,leethomason,tinyxml2,$(TINYXML2_VERSION))
TINYXML2_LICENSE = Zlib
TINYXML2_LICENSE_FILES = readme.md
TINYXML2_INSTALL_STAGING = YES

$(eval $(cmake-package))
