################################################################################
#
# libxslt
#
################################################################################

LIBXSLT_VERSION = 1.1.32
LIBXSLT_SITE = ftp://xmlsoft.org/libxslt
LIBXSLT_INSTALL_STAGING = YES
LIBXSLT_LICENSE = MIT
LIBXSLT_LICENSE_FILES = COPYING

LIBXSLT_CONF_OPTS = \
	--with-gnu-ld \
	--without-debug \
	--without-python
LIBXSLT_CONFIG_SCRIPTS = xslt-config
LIBXSLT_DEPENDENCIES = host-pkgconf libxml2

# GCC bug with Os/O2/O3, PR77311
# error: unable to find a register to spill in class 'CCREGS'
ifeq ($(BR2_bfin),y)
LIBXSLT_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -O1"
endif

# If we have enabled libgcrypt then use it, else disable crypto support.
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBXSLT_DEPENDENCIES += libgcrypt
LIBXSLT_CONF_ENV += LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
else
LIBXSLT_CONF_OPTS += --without-crypto
endif

HOST_LIBXSLT_CONF_OPTS = --without-debug --without-python --without-crypto

HOST_LIBXSLT_DEPENDENCIES = host-pkgconf host-libxml2

$(eval $(autotools-package))
$(eval $(host-autotools-package))
