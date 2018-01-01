################################################################################
#
# libbdplus
#
################################################################################

LIBBDPLUS_VERSION = 0.1.2
LIBBDPLUS_SITE = http://download.videolan.org/pub/videolan/libbdplus/$(LIBBDPLUS_VERSION)
LIBBDPLUS_SOURCE = libbdplus-$(LIBBDPLUS_VERSION).tar.bz2
LIBBDPLUS_LICENSE = LGPL-2.1+
LIBBDPLUS_LICENSE_FILES = COPYING
LIBBDPLUS_INSTALL_STAGING = YES
LIBBDPLUS_DEPENDENCIES = libgcrypt
LIBBDPLUS_CONF_OPTS = \
	--disable-werror \
	--disable-extra-warnings \
	--disable-optimizations \
	--disable-examples \
	--disable-debug \
	--with-gnu-ld \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr

ifeq ($(BR2_PACKAGE_LIBAACS),y)
LIBBDPLUS_DEPENDENCIES += libaacs
LIBBDPLUS_CONF_OPTS += --with-libaacs
else
LIBBDPLUS_CONF_OPTS += --without-libaacs
endif

$(eval $(autotools-package))
