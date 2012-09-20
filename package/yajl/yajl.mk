################################################################################
#
# yajl
#
################################################################################

YAJL_VERSION = 2.0.4
YAJL_SITE = http://github.com/lloyd/yajl/tarball/$(YAJL_VERSION)
YAJL_INSTALL_STAGING = YES
YAJL_LICENSE = ISC
YAJL_LICENSE_FILES = COPYING

$(eval $(cmake-package))
