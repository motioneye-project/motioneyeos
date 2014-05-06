################################################################################
#
# protobuf-c
#
################################################################################

PROTOBUF_C_VERSION = 1d1ad931dfda273bb12b9925d4b8cc413131af03
PROTOBUF_C_SITE = $(call github,protobuf-c,protobuf-c,$(PROTOBUF_C_VERSION))
PROTOBUF_C_DEPENDENCIES = host-protobuf-c
HOST_PROTOBUF_C_DEPENDENCIES = host-protobuf
PROTOBUF_C_MAKE = $(MAKE1)
PROTOBUF_C_CONF_OPT = --disable-protoc
PROTOBUF_C_INSTALL_STAGING = YES
PROTOBUF_C_LICENSE = BSD-3c
PROTOBUF_C_AUTORECONF = YES
HOST_PROTOBUF_C_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
