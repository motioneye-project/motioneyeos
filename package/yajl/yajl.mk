################################################################################
#
# yajl
#
################################################################################

YAJL_VERSION = 2.1.0
YAJL_SITE = $(call github,lloyd,yajl,$(YAJL_VERSION))
YAJL_INSTALL_STAGING = YES
YAJL_LICENSE = ISC
YAJL_LICENSE_FILES = COPYING

$(eval $(cmake-package))
