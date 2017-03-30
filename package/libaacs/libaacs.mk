################################################################################
#
# libaacs
#
################################################################################

LIBAACS_VERSION = 0.8.1
LIBAACS_SITE = http://download.videolan.org/pub/videolan/libaacs/$(LIBAACS_VERSION)
LIBAACS_SOURCE = libaacs-$(LIBAACS_VERSION).tar.bz2
LIBAACS_LICENSE = LGPL-2.1+
LIBAACS_LICENSE_FILES = COPYING
LIBAACS_INSTALL_STAGING = YES
LIBAACS_DEPENDENCIES = host-bison host-flex libgcrypt
LIBAACS_CONF_OPTS = \
	--disable-werror \
	--disable-extra-warnings \
	--disable-optimizations \
	--disable-examples \
	--disable-debug \
	--with-gnu-ld \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr

$(eval $(autotools-package))
