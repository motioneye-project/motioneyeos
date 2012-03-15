#############################################################
#
# protobuf
#
#############################################################
PROTOBUF_VERSION = 2.4.1
PROTOBUF_SOURCE = protobuf-$(PROTOBUF_VERSION).tar.gz
PROTOBUF_SITE = http://protobuf.googlecode.com/files/

# N.B. Need to use host protoc during cross compilation.
PROTOBUF_DEPENDENCIES = host-protobuf
PROTOBUF_CONF_OPT = --with-protoc=$(HOST_DIR)/usr/bin/protoc

PROTOBUF_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_ZLIB),y)
PROTOBUF_DEPENDENCIES += zlib
endif

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
