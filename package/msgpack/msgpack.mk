################################################################################
#
# msgpack
#
################################################################################

MSGPACK_VERSION = 2.1.5
MSGPACK_SITE = $(call github,msgpack,msgpack-c,cpp-$(MSGPACK_VERSION))
MSGPACK_LICENSE = BSL-1.0
MSGPACK_LICENSE_FILES = COPYING LICENSE_1_0.txt
MSGPACK_INSTALL_STAGING = YES

$(eval $(cmake-package))
