################################################################################
#
# yajl
#
################################################################################

YAJL_VERSION = 2.0.4
YAJL_SITE = git://github.com/lloyd/yajl.git
YAJL_INSTALL_STAGING = YES
YAJL_LICENSE = ISC
YAJL_LICENSE_FILES = COPYING

$(eval $(cmake-package))
