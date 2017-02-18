################################################################################
#
# wireshark
#
################################################################################

WIRESHARK_VERSION = 2.0.3
WIRESHARK_SOURCE = wireshark-$(WIRESHARK_VERSION).tar.bz2
WIRESHARK_SITE = http://www.wireshark.org/download/src/all-versions
WIRESHARK_LICENSE = wireshark license
WIRESHARK_LICENSE_FILES = COPYING
WIRESHARK_DEPENDENCIES = host-pkgconf libpcap libglib2
WIRESHARK_CONF_ENV = \
	ac_cv_path_PCAP_CONFIG=$(STAGING_DIR)/usr/bin/pcap-config

# patch touching configure.ac
WIRESHARK_AUTORECONF = YES

# wireshark adds -I$includedir to CFLAGS, causing host/target headers mixup.
# Work around it by pointing includedir at staging
WIRESHARK_CONF_OPTS = \
	--without-krb5 \
	--disable-usr-local \
	--enable-static=no \
	--with-libsmi=no \
	--with-lua=no \
	--with-pcap=$(STAGING_DIR)/usr \
	--includedir=$(STAGING_DIR)/usr/include

# wireshark GUI options
ifeq ($(BR2_PACKAGE_LIBGTK3),y)
WIRESHARK_CONF_OPTS += --with-gtk3=yes
WIRESHARK_DEPENDENCIES += libgtk3
else ifeq ($(BR2_PACKAGE_LIBGTK2),y)
WIRESHARK_CONF_OPTS += --with-gtk2=yes
WIRESHARK_DEPENDECIES += libgtk2
else
WIRESHARK_CONF_OPTS += --with-gtk3=no --with-gtk2=no
endif

# Qt4 needs accessibility, we don't support it
ifeq ($(BR2_PACKAGE_QT5BASE_WIDGETS),y)
WIRESHARK_CONF_OPTS += --with-qt=5
WIRESHARK_DEPENDENCIES += qt5base
# Seems it expects wrappers and passes a -qt=X parameter for version
WIRESHARK_MAKE_OPTS += \
	MOC="$(HOST_DIR)/usr/bin/moc" \
	RCC="$(HOST_DIR)/usr/bin/rcc" \
	UIC="$(HOST_DIR)/usr/bin/uic"
else
WIRESHARK_CONF_OPTS += --with-qt=no
endif

# No GUI at all
ifeq ($(BR2_PACKAGE_LIBGTK2)$(BR2_PACKAGE_LIBGTK3)$(BR2_PACKAGE_QT5BASE_WIDGETS),)
WIRESHARK_CONF_OPTS += --disable-wireshark
endif

ifeq ($(BR2_PACKAGE_C_ARES),y)
WIRESHARK_CONF_OPTS += --with-c-ares=$(STAGING_DIR)/usr
WIRESHARK_DEPENDENCIES += c-ares
else
WIREHARK_CONF_OPTS += --without-c-ares
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
WIRESHARK_CONF_ENV = LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
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

$(eval $(autotools-package))
