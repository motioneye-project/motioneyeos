################################################################################
#
# wireshark
#
################################################################################

WIRESHARK_VERSION = 3.2.5
WIRESHARK_SOURCE = wireshark-$(WIRESHARK_VERSION).tar.xz
WIRESHARK_SITE = https://www.wireshark.org/download/src/all-versions
WIRESHARK_LICENSE = wireshark license
WIRESHARK_LICENSE_FILES = COPYING
WIRESHARK_DEPENDENCIES = host-pkgconf host-python3 libgcrypt libpcap libglib2 \
	speexdsp

WIRESHARK_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	PATH="$(@D)/bin:$(BR_PATH)"

WIRESHARK_CONF_OPTS = \
	-DDISABLE_WERROR=ON \
	-DENABLE_PCAP=ON \
	-DENABLE_SMI=OFF

# wireshark needs the host version of lemon during compilation.
# This binrary is provided by sqlite-src (which is different from
# sqlite-autotools that is currently packaged in buildroot) moreover wireshark
# adds several patches.
# So, instead of creating a separate host package and installing lemon to
# $(HOST_DIR), this binary is compiled on-the-fly
define WIRESHARK_BUILD_LEMON_TOOL
	cd $(@D); \
	mkdir -p $(@D)/bin; \
	$(HOSTCC) $(HOST_CFLAGS) -o $(@D)/bin/lemon tools/lemon/lemon.c
endef

WIRESHARK_PRE_BUILD_HOOKS += WIRESHARK_BUILD_LEMON_TOOL

ifeq ($(BR2_PACKAGE_WIRESHARK_GUI),y)
WIRESHARK_CONF_OPTS += -DBUILD_wireshark=ON
WIRESHARK_DEPENDENCIES += qt5base qt5multimedia qt5svg qt5tools
else
WIRESHARK_CONF_OPTS += -DBUILD_wireshark=OFF
endif

ifeq ($(BR2_PACKAGE_BCG729),y)
WIRESHARK_CONF_OPTS += -DENABLE_BCG729=ON
WIRESHARK_DEPENDENCIES += bcg729
else
WIRESHARK_CONF_OPTS += -DENABLE_BCG729=OFF
endif

ifeq ($(BR2_PACKAGE_BROTLI),y)
WIRESHARK_CONF_OPTS += -DENABLE_BROTLI=ON
WIRESHARK_DEPENDENCIES += brotli
else
WIRESHARK_CONF_OPTS += -DENABLE_BROTLI=OFF
endif

ifeq ($(BR2_PACKAGE_C_ARES),y)
WIRESHARK_CONF_OPTS += -DENABLE_CARES=ON
WIRESHARK_DEPENDENCIES += c-ares
else
WIRESHARK_CONF_OPTS += -DENABLE_CARES=OFF
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
WIRESHARK_CONF_OPTS += -DENABLE_GNUTLS=ON
WIRESHARK_DEPENDENCIES += gnutls
else
WIRESHARK_CONF_OPTS += -DENABLE_GNUTLS=OFF
endif

ifeq ($(BR2_PACKAGE_LIBKRB5),y)
WIRESHARK_CONF_OPTS += -DENABLE_KERBEROS=ON
WIRESHARK_DEPENDENCIES += libkrb5
else
WIRESHARK_CONF_OPTS += -DENABLE_KERBEROS=OFF
endif

ifeq ($(BR2_PACKAGE_LIBMAXMINDDB),y)
WIRESHARK_CONF_OPTS += -DBUILD_mmdbresolve=ON
WIRESHARK_DEPENDENCIES += libmaxminddb
else
WIRESHARK_CONF_OPTS += -DBUILD_mmdbresolve=OFF
endif

ifeq ($(BR2_PACKAGE_LIBNL),y)
WIRESHARK_CONF_OPTS += -DENABLE_NETLINK=ON
WIRESHARK_DEPENDENCIES += libnl
else
WIRESHARK_CONF_OPTS += -DENABLE_NETLINK=OFF
endif

ifeq ($(BR2_PACKAGE_LIBSSH),y)
WIRESHARK_CONF_OPTS += -DENABLE_LIBSSH=ON
WIRESHARK_DEPENDENCIES += libssh
else
WIRESHARK_CONF_OPTS += -DENABLE_LIBSSH=OFF
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
WIRESHARK_CONF_OPTS += -DENABLE_LIBXML2=ON
WIRESHARK_DEPENDENCIES += libxml2
else
WIRESHARK_CONF_OPTS += -DENABLE_LIBXML2=OFF
endif

# no support for lua53 yet
ifeq ($(BR2_PACKAGE_LUA_5_1),y)
WIRESHARK_CONF_OPTS += -DENABLE_LUA=ON
WIRESHARK_DEPENDENCIES += lua
else
WIRESHARK_CONF_OPTS += -DENABLE_LUA=OFF
endif

ifeq ($(BR2_PACKAGE_LZ4),y)
WIRESHARK_CONF_OPTS += -DENABLE_LZ4=ON
WIRESHARK_DEPENDENCIES += lz4
else
WIRESHARK_CONF_OPTS += -DENABLE_LZ4=OFF
endif

ifeq ($(BR2_PACKAGE_NGHTTP2),y)
WIRESHARK_CONF_OPTS += -DENABLE_NGHTTP2=ON
WIRESHARK_DEPENDENCIES += nghttp2
else
WIRESHARK_CONF_OPTS += -DENABLE_NGHTTP2=OFF
endif

ifeq ($(BR2_PACKAGE_SBC),y)
WIRESHARK_CONF_OPTS += -DENABLE_SBC=ON
WIRESHARK_DEPENDENCIES += sbc
else
WIRESHARK_CONF_OPTS += -DENABLE_SBC=OFF
endif

ifeq ($(BR2_PACKAGE_SNAPPY),y)
WIRESHARK_CONF_OPTS += -DENABLE_SNAPPY=ON
WIRESHARK_DEPENDENCIES += snappy
else
WIRESHARK_CONF_OPTS += -DENABLE_SNAPPY=OFF
endif

ifeq ($(BR2_PACKAGE_SPANDSP),y)
WIRESHARK_CONF_OPTS += -DENABLE_SPANDSP=ON
WIRESHARK_DEPENDENCIES += spandsp
else
WIRESHARK_CONF_OPTS += -DENABLE_SPANDSP=OFF
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
WIRESHARK_CONF_OPTS += -DBUILD_sdjournal=ON
WIRESHARK_DEPENDENCIES += systemd
else
WIRESHARK_CONF_OPTS += -DBUILD_sdjournal=OFF
endif

# Disable plugins as some of them (like l16mono) can't be built
# statically. ENABLE_STATIC=ON actually means "disable shared library"
# and ENABLE_STATIC=OFF means "enable shared library". So for the
# BR2_SHARED_STATIC_LIBS=y case, we want ENABLE_STATIC=OFF even if
# that sounds counter-intuitive.
ifeq ($(BR2_STATIC_LIBS),y)
WIRESHARK_CONF_OPTS += \
	-DENABLE_PLUGINS=OFF \
	-DENABLE_STATIC=ON \
	-DUSE_STATIC=ON
else
WIRESHARK_CONF_OPTS += \
	-DENABLE_PLUGINS=ON \
	-DENABLE_STATIC=OFF \
	-DUSE_STATIC=OFF
endif

define WIRESHARK_REMOVE_DOCS
	find $(TARGET_DIR)/usr/share/wireshark -name '*.txt' -print0 \
		-o -name '*.html' -print0 | xargs -0 rm -f
endef

WIRESHARK_POST_INSTALL_TARGET_HOOKS += WIRESHARK_REMOVE_DOCS

$(eval $(cmake-package))
