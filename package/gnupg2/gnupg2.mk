################################################################################
#
# gnupg2
#
################################################################################

GNUPG2_VERSION = 2.2.4
GNUPG2_SOURCE = gnupg-$(GNUPG2_VERSION).tar.bz2
GNUPG2_SITE = https://gnupg.org/ftp/gcrypt/gnupg
GNUPG2_LICENSE = GPL-3.0+
GNUPG2_LICENSE_FILES = COPYING
GNUPG2_DEPENDENCIES = zlib libgpg-error libgcrypt libassuan libksba libnpth \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv) host-pkgconf

GNUPG2_CONF_OPTS = \
	--disable-rpath --disable-regex --disable-doc \
	--with-libgpg-error-prefix=$(STAGING_DIR)/usr \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr \
	--with-libassuan-prefix=$(STAGING_DIR)/usr \
	--with-ksba-prefix=$(STAGING_DIR)/usr \
	--with-npth-prefix=$(STAGING_DIR)/usr

ifneq ($(BR2_PACKAGE_GNUPG2_GPGV),y)
define GNUPG2_REMOVE_GPGV
	rm -f $(TARGET_DIR)/usr/bin/gpgv
endef
GNUPG2_POST_INSTALL_TARGET_HOOKS += GNUPG2_REMOVE_GPGV
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
GNUPG2_CONF_OPTS += --enable-bzip2 --with-bzip2=$(STAGING_DIR)
GNUPG2_DEPENDENCIES += bzip2
else
GNUPG2_CONF_OPTS += --disable-bzip2
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
GNUPG2_CONF_OPTS += --enable-gnutls
GNUPG2_DEPENDENCIES += gnutls
else
GNUPG2_CONF_OPTS += --disable-gnutls
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
GNUPG2_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include/libusb-1.0"
GNUPG2_CONF_OPTS += --enable-ccid-driver
GNUPG2_DEPENDENCIES += libusb
else
GNUPG2_CONF_OPTS += --disable-ccid-driver
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
GNUPG2_CONF_OPTS += --with-readline=$(STAGING_DIR)
GNUPG2_DEPENDENCIES += readline
else
GNUPG2_CONF_OPTS += --without-readline
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
GNUPG2_CONF_OPTS += --enable-sqlite
GNUPG2_DEPENDENCIES += sqlite
else
GNUPG2_CONF_OPTS += --disable-sqlite
endif

$(eval $(autotools-package))
