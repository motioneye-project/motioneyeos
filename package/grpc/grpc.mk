################################################################################
#
# grpc
#
################################################################################

GRPC_VERSION = 1.18.0
GRPC_SITE = $(call github,grpc,grpc,v$(GRPC_VERSION))
GRPC_LICENSE = Apache-2.0
GRPC_LICENSE_FILES = LICENSE

GRPC_INSTALL_STAGING = YES

# Need to use host grpc_cpp_plugin during cross compilation.
GRPC_DEPENDENCIES = c-ares host-grpc openssl protobuf zlib
HOST_GRPC_DEPENDENCIES = host-c-ares host-openssl host-protobuf host-zlib

# gRPC_CARES_PROVIDER=package won't work because it requires c-ares to have
# installed a cmake config file, but buildroot uses c-ares' autotools build,
# which doesn't do this.  These CARES settings trick the gRPC cmake code into
# not looking for c-ares at all and yet still linking with the library.
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

# Set GPR_DISABLE_WRAPPED_MEMCPY otherwise build will fail on x86_64 with uclibc
# because grpc tries to link with memcpy@GLIBC_2.2.5
ifeq ($(BR2_x86_64):$(BR2_TOOLCHAIN_USES_GLIBC),y:)
GRPC_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -DGPR_DISABLE_WRAPPED_MEMCPY" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -DGPR_DISABLE_WRAPPED_MEMCPY"
endif

HOST_GRPC_CONF_OPTS = \
	-D_gRPC_CARES_LIBRARIES=cares \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_PROTOBUF_PROVIDER=package \
	-DgRPC_SSL_PROVIDER=package \
	-DgRPC_ZLIB_PROVIDER=package

$(eval $(cmake-package))
$(eval $(host-cmake-package))
