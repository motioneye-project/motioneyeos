################################################################################
#
# grpc
#
################################################################################

GRPC_VERSION = v1.16.1
GRPC_SITE = $(call github,grpc,grpc,$(GRPC_VERSION))
GRPC_LICENSE = Apache-2.0
GRPC_LICENSE_FILES = LICENSE

GRPC_INSTALL_STAGING = YES

# Need to use host grpc_cpp_plugin during cross compilation.
GRPC_DEPENDENCIES = c-ares host-grpc openssl protobuf zlib
HOST_GRPC_DEPENDENCIES = host-c-ares host-openssl host-protobuf host-zlib

GRPC_CONF_OPTS = \
	-D_gRPC_CARES_LIBRARIES=cares \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_PROTOBUF_PROVIDER=package \
	-DgRPC_SSL_PROVIDER=package \
	-DgRPC_ZLIB_PROVIDER=package \
	-DgRPC_NATIVE_CPP_PLUGIN=$(HOST_DIR)/bin/grpc_cpp_plugin

# grpc can use __atomic builtins, so we need to link with
# libatomic when available
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
GRPC_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-latomic
endif

HOST_GRPC_CONF_OPTS = \
	-D_gRPC_CARES_LIBRARIES=cares \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_PROTOBUF_PROVIDER=package \
	-DgRPC_SSL_PROVIDER=package \
	-DgRPC_ZLIB_PROVIDER=package

$(eval $(cmake-package))
$(eval $(host-cmake-package))
