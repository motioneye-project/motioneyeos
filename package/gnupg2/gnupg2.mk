################################################################################
#
# gnupg2
#
################################################################################

GNUPG2_VERSION = 2.0.25
GNUPG2_SOURCE = gnupg-$(GNUPG2_VERSION).tar.bz2
GNUPG2_SITE = ftp://ftp.gnupg.org/gcrypt/gnupg
GNUPG2_LICENSE = GPLv3+
GNUPG2_LICENSE_FILES = COPYING
GNUPG2_DEPENDENCIES = zlib libgpg-error libgcrypt libassuan libksba libpthsem
GNUPG2_CONF_OPT = \
	--disable-rpath --disable-regex --disable-doc \
	--with-libgpg-error-prefix=$(STAGING_DIR)/usr \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr \
	--with-libassuan-prefix=$(STAGING_DIR)/usr \
	--with-ksba-prefix=$(STAGING_DIR)/usr \
	--with-pth-prefix=$(STAGING_DIR)/usr

ifneq ($(BR2_PACKAGE_GNUPG2_GPGV2),y)
define GNUPG2_REMOVE_GPGV2
	rm -f $(TARGET_DIR)/usr/bin/gpgv2
endef
GNUPG2_POST_INSTALL_TARGET_HOOKS += GNUPG2_REMOVE_GPGV2
endif

$(eval $(autotools-package))
