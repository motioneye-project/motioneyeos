################################################################################
#
# wireshark
#
################################################################################

WIRESHARK_VERSION = 2.2.11
WIRESHARK_SOURCE = wireshark-$(WIRESHARK_VERSION).tar.bz2
WIRESHARK_SITE = https://www.wireshark.org/download/src/all-versions
WIRESHARK_LICENSE = wireshark license
WIRESHARK_LICENSE_FILES = COPYING
WIRESHARK_DEPENDENCIES = host-pkgconf libpcap libglib2
WIRESHARK_CONF_ENV = \
	PCAP_CONFIG=$(STAGING_DIR)/usr/bin/pcap-config

# patch touching configure.ac
WIRESHARK_AUTORECONF = YES

# wireshark adds -I$includedir to CFLAGS, causing host/target headers mixup.
# Work around it by pointing includedir at staging
WIRESHARK_CONF_OPTS = \
	--without-krb5 \
	--enable-static=no \
	--with-libsmi=no \
	--with-lua=no \
	--with-pcap=$(STAGING_DIR)/usr \
	--includedir=$(STAGING_DIR)/usr/include

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

ifeq ($(BR2_PACKAGE_C_ARES),y)
WIRESHARK_CONF_OPTS += --with-c-ares=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += c-ares
else
WIRESHARK_CONF_OPTS += --without-c-ares
endif

ifeq ($(BR2_PACKAGE_GEOIP),y)
WIRESHARK_CONF_OPTS += --with-geoip=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += geoip
else
WIRESHARK_CONF_OPTS += --without-geoip
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
WIRESHARK_CONF_OPTS += --with-gnutls=yes
WIRESHARK_DEPENDENCIES += gnutls
else
WIRESHARK_CONF_OPTS += --with-gnutls=no
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
WIRESHARK_CONF_ENV += LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
WIRESHARK_CONF_OPTS += --with-gcrypt=yes
WIRESHARK_DEPENDENCIES += libgcrypt
else
WIRESHARK_CONF_OPTS += --with-gcrypt=no
endif

ifeq ($(BR2_PACKAGE_LIBNL),y)
WIRESHARK_CONF_OPTS += --with-libnl
WIRESHARK_DEPENDENCIES += libnl
else
WIRESHARK_CONF_OPTS += --without-libnl
endif

ifeq ($(BR2_PACKAGE_SBC),y)
WIRESHARK_CONF_OPTS += --with-sbc=yes
WIRESHARK_DEPENDENCIES += sbc
else
WIRESHARK_CONF_OPTS += --with-sbc=no
endif

define WIRESHARK_REMOVE_DOCS
	find $(TARGET_DIR)/usr/share/wireshark -name '*.txt' -print0 \
		-o -name '*.html' -print0 | xargs -0 rm -f
endef

WIRESHARK_POST_INSTALL_TARGET_HOOKS += WIRESHARK_REMOVE_DOCS

$(eval $(autotools-package))
