################################################################################
#
# wireshark
#
################################################################################

WIRESHARK_VERSION = 2.6.4
WIRESHARK_SOURCE = wireshark-$(WIRESHARK_VERSION).tar.xz
WIRESHARK_SITE = https://www.wireshark.org/download/src/all-versions
WIRESHARK_LICENSE = wireshark license
WIRESHARK_LICENSE_FILES = COPYING
WIRESHARK_DEPENDENCIES = host-pkgconf libgcrypt libpcap libglib2
WIRESHARK_CONF_ENV = \
	LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config \
	PCAP_CONFIG=$(STAGING_DIR)/usr/bin/pcap-config

WIRESHARK_CONF_OPTS = \
	--disable-guides \
	--enable-static=no \
	--with-libsmi=no \
	--with-pcap=yes

# wireshark GUI options
ifeq ($(BR2_PACKAGE_LIBGTK3),y)
WIRESHARK_CONF_OPTS += --with-gtk=3
WIRESHARK_DEPENDENCIES += libgtk3
else ifeq ($(BR2_PACKAGE_LIBGTK2),y)
WIRESHARK_CONF_OPTS += --with-gtk=2
WIRESHARK_DEPENDENCIES += libgtk2
else
WIRESHARK_CONF_OPTS += --with-gtk=no
endif

# Qt4 needs accessibility, we don't support it
ifeq ($(BR2_PACKAGE_WIRESHARK_QT),y)
WIRESHARK_CONF_OPTS += --with-qt=5
WIRESHARK_DEPENDENCIES += qt5base qt5tools
WIRESHARK_CONF_ENV += ac_cv_path_QTCHOOSER=""
# Seems it expects wrappers and passes a -qt=X parameter for version
WIRESHARK_MAKE_OPTS += \
	MOC="$(HOST_DIR)/bin/moc" \
	RCC="$(HOST_DIR)/bin/rcc" \
	UIC="$(HOST_DIR)/bin/uic"
else
WIRESHARK_CONF_OPTS += --with-qt=no
endif

# No GUI at all
ifeq ($(BR2_PACKAGE_WIRESHARK_GUI),)
WIRESHARK_CONF_OPTS += --disable-wireshark
endif

ifeq ($(BR2_PACKAGE_BCG729),y)
WIRESHARK_CONF_OPTS += --with-bcg729=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += bcg729
else
WIRESHARK_CONF_OPTS += --without-bcg729
endif

ifeq ($(BR2_PACKAGE_C_ARES),y)
WIRESHARK_CONF_OPTS += --with-c-ares=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += c-ares
else
WIRESHARK_CONF_OPTS += --without-c-ares
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
WIRESHARK_CONF_OPTS += --with-gnutls=yes
WIRESHARK_DEPENDENCIES += gnutls
else
WIRESHARK_CONF_OPTS += --with-gnutls=no
endif

ifeq ($(BR2_PACKAGE_LIBKRB5),y)
WIRESHARK_CONF_OPTS += --with-krb5=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += libkrb5
else
WIRESHARK_CONF_OPTS += --without-krb5
endif

ifeq ($(BR2_PACKAGE_LIBMAXMINDDB),y)
WIRESHARK_CONF_OPTS += --with-maxminddb=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += libmaxminddb
else
WIRESHARK_CONF_OPTS += --without-maxminddb
endif

ifeq ($(BR2_PACKAGE_LIBNL),y)
WIRESHARK_CONF_OPTS += --with-libnl
WIRESHARK_DEPENDENCIES += libnl
else
WIRESHARK_CONF_OPTS += --without-libnl
endif

ifeq ($(BR2_PACKAGE_LIBSSH),y)
WIRESHARK_CONF_OPTS += --with-libssh=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += libssh
else
WIRESHARK_CONF_OPTS += --without-libssh
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
WIRESHARK_CONF_OPTS += --with-libxml2
WIRESHARK_DEPENDENCIES += libxml2
else
WIRESHARK_CONF_OPTS += --without-libxml2
endif

# no support for lua53 yet
ifeq ($(BR2_PACKAGE_LUA_5_1)$(BR2_PACKAGE_LUA_5_2),y)
WIRESHARK_CONF_OPTS += --with-lua
WIRESHARK_DEPENDENCIES += lua
else
WIRESHARK_CONF_OPTS += --without-lua
endif

ifeq ($(BR2_PACKAGE_LZ4),y)
WIRESHARK_CONF_OPTS += --with-lz4=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += lz4
else
WIRESHARK_CONF_OPTS += --without-lz4
endif

ifeq ($(BR2_PACKAGE_NGHTTP2),y)
WIRESHARK_CONF_OPTS += --with-nghttp2=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += nghttp2
else
WIRESHARK_CONF_OPTS += --without-nghttp2
endif

ifeq ($(BR2_PACKAGE_SBC),y)
WIRESHARK_CONF_OPTS += --with-sbc=yes
WIRESHARK_DEPENDENCIES += sbc
else
WIRESHARK_CONF_OPTS += --with-sbc=no
endif

ifeq ($(BR2_PACKAGE_SNAPPY),y)
WIRESHARK_CONF_OPTS += --with-snappy=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += snappy
ifeq ($(BR2_STATIC_LIBS),y)
WIRESHARK_CONF_ENV += LIBS=-lstdc++
endif
else
WIRESHARK_CONF_OPTS += --without-snappy
endif

define WIRESHARK_REMOVE_DOCS
	find $(TARGET_DIR)/usr/share/wireshark -name '*.txt' -print0 \
		-o -name '*.html' -print0 | xargs -0 rm -f
endef

WIRESHARK_POST_INSTALL_TARGET_HOOKS += WIRESHARK_REMOVE_DOCS

$(eval $(autotools-package))
