################################################################################
#
# libxslt
#
################################################################################

LIBXSLT_VERSION = 1.1.34
LIBXSLT_SITE = http://xmlsoft.org/sources
LIBXSLT_INSTALL_STAGING = YES
LIBXSLT_LICENSE = MIT
LIBXSLT_LICENSE_FILES = COPYING

LIBXSLT_CONF_OPTS = \
	--with-gnu-ld \
	--without-debug \
	--without-python \
	--with-libxml-prefix=$(STAGING_DIR)/usr
LIBXSLT_CONFIG_SCRIPTS = xslt-config
LIBXSLT_DEPENDENCIES = host-pkgconf libxml2

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
