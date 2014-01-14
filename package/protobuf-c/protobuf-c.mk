################################################################################
#
# protobuf-c
#
################################################################################

PROTOBUF_C_VERSION = 0.15
PROTOBUF_C_SITE = http://protobuf-c.googlecode.com/files
PROTOBUF_C_DEPENDENCIES = host-protobuf-c
HOST_PROTOBUF_C_DEPENDENCIES = host-protobuf
PROTOBUF_C_MAKE = $(MAKE1)
PROTOBUF_C_CONF_OPT = --disable-protoc
PROTOBUF_C_INSTALL_STAGING = YES
PROTOBUF_C_LICENSE = BSD-3c

$(eval $(autotools-package))
$(eval $(host-autotools-package))
