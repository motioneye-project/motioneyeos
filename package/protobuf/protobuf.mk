################################################################################
#
# protobuf
#
################################################################################

PROTOBUF_VERSION = 2.6.0
PROTOBUF_SITE = https://github.com/google/protobuf/releases/download/v$(PROTOBUF_VERSION)/
PROTOBUF_LICENSE = BSD-3c
PROTOBUF_LICENSE_FILES = COPYING.txt

# N.B. Need to use host protoc during cross compilation.
PROTOBUF_DEPENDENCIES = host-protobuf
PROTOBUF_CONF_OPTS = --with-protoc=$(HOST_DIR)/usr/bin/protoc

PROTOBUF_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_ZLIB),y)
PROTOBUF_DEPENDENCIES += zlib
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
