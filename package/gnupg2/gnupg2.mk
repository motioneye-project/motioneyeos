################################################################################
#
# gnupg2
#
################################################################################

GNUPG2_VERSION = 2.0.29
GNUPG2_SOURCE = gnupg-$(GNUPG2_VERSION).tar.bz2
GNUPG2_SITE = ftp://ftp.gnupg.org/gcrypt/gnupg
GNUPG2_LICENSE = GPLv3+
GNUPG2_LICENSE_FILES = COPYING
GNUPG2_DEPENDENCIES = zlib libgpg-error libgcrypt libassuan libksba libpthsem \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)
GNUPG2_CONF_OPTS = \
	--disable-rpath --disable-regex --disable-doc \
	--with-libgpg-error-prefix=$(STAGING_DIR)/usr \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr \
	--with-libassuan-prefix=$(STAGING_DIR)/usr \
	--with-ksba-prefix=$(STAGING_DIR)/usr \
	--with-pth-prefix=$(STAGING_DIR)/usr
GNUPG2_CONF_ENV = gl_cv_header_working_stdint_h=yes

ifneq ($(BR2_PACKAGE_GNUPG2_GPGV2),y)
define GNUPG2_REMOVE_GPGV2
	rm -f $(TARGET_DIR)/usr/bin/gpgv2
endef
GNUPG2_POST_INSTALL_TARGET_HOOKS += GNUPG2_REMOVE_GPGV2
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
GNUPG2_CONF_OPTS += --enable-bzip2 --with-bzip2=$(STAGING_DIR)
GNUPG2_DEPENDENCIES += bzip2
else
GNUPG2_CONF_OPTS += --disable-bzip2
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
GNUPG2_CONF_OPTS += --with-readline=$(STAGING_DIR)
GNUPG2_DEPENDENCIES += readline
else
GNUPG2_CONF_OPTS += --without-readline
endif

$(eval $(autotools-package))
