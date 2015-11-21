################################################################################
#
# yajl
#
################################################################################

YAJL_VERSION = 2.0.4
YAJL_SITE = $(call github,lloyd,yajl,$(YAJL_VERSION))
YAJL_INSTALL_STAGING = YES
YAJL_LICENSE = ISC
YAJL_LICENSE_FILES = COPYING
YAJL_PATCH = https://github.com/vriera/yajl/commit/6d09f11b8fd358cab0e31b965327e64a599f9ce9.patch

$(eval $(cmake-package))
