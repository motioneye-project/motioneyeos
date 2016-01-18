################################################################################
#
# luvi
#
################################################################################

LUVI_VERSION = v2.5.1
LUVI_SOURCE = luvi-src-$(LUVI_VERSION).tar.gz
LUVI_SITE = https://github.com/luvit/luvi/releases/download/$(LUVI_VERSION)
LUVI_LICENSE = Apache-2.0
LUVI_LICENSE_FILES = LICENSE.txt
LUVI_DEPENDENCIES = libuv luajit luv host-luajit

# Dispatch all architectures of LuaJIT
ifeq ($(BR2_i386),y)
LUVI_TARGET_ARCH = x86
else ifeq ($(BR2_x86_64),y)
LUVI_TARGET_ARCH = x64
else ifeq ($(BR2_powerpc),y)
LUVI_TARGET_ARCH = ppc
else ifeq ($(BR2_arm)$(BR2_armeb),y)
LUVI_TARGET_ARCH = arm
else ifeq ($(BR2_mips),y)
LUVI_TARGET_ARCH = mips
else ifeq ($(BR2_mipsel),y)
LUVI_TARGET_ARCH = mipsel
else
LUVI_TARGET_ARCH = $(BR2_ARCH)
endif

# Bundled lua bindings have to be linked statically into the luvi executable
LUVI_CONF_OPTS = \
	-DBUILD_SHARED_LIBS=OFF \
	-DWithSharedLibluv=ON \
	-DTARGET_ARCH=$(LUVI_TARGET_ARCH) \
	-DLUA_PATH=$(HOST_DIR)/usr/share/luajit-2.0.4/?.lua

# Add "rex" module (PCRE via bundled lrexlib)
ifeq ($(BR2_PACKAGE_PCRE),y)
LUVI_DEPENDENCIES += pcre
LUVI_CONF_OPTS += -DWithPCRE=ON -DWithSharedPCRE=ON
else
LUVI_CONF_OPTS += -DWithPCRE=OFF -DWithSharedPCRE=OFF
endif

# Add "ssl" module (via bundled lua-openssl)
ifeq ($(BR2_PACKAGE_OPENSSL),y)
LUVI_DEPENDENCIES += openssl
LUVI_CONF_OPTS += -DWithOpenSSL=ON -DWithOpenSSLASM=ON -DWithSharedOpenSSL=ON
else
LUVI_CONF_OPTS += -DWithOpenSSL=OFF -DWithOpenSSLASM=OFF -DWithSharedOpenSSL=OFF
endif

# Add "zlib" module (via bundled lua-zlib)
ifeq ($(BR2_PACKAGE_ZLIB),y)
LUVI_DEPENDENCIES += zlib
LUVI_CONF_OPTS += -DWithZLIB=ON -DWithSharedZLIB=ON
else
LUVI_CONF_OPTS += -DWithZLIB=OFF -DWithSharedZLIB=OFF
endif

$(eval $(cmake-package))
