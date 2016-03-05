################################################################################
#
# protobuf-c
#
################################################################################

PROTOBUF_C_VERSION = v1.1.1
PROTOBUF_C_SITE = $(call github,protobuf-c,protobuf-c,$(PROTOBUF_C_VERSION))
PROTOBUF_C_DEPENDENCIES = host-protobuf-c
HOST_PROTOBUF_C_DEPENDENCIES = host-protobuf host-pkgconf
PROTOBUF_C_MAKE = $(MAKE1)
PROTOBUF_C_CONF_OPTS = --disable-protoc
PROTOBUF_C_INSTALL_STAGING = YES
PROTOBUF_C_LICENSE = BSD-2c
PROTOBUF_C_LICENSE_FILES = LICENSE
PROTOBUF_C_AUTORECONF = YES
HOST_PROTOBUF_C_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
