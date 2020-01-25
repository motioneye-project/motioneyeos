################################################################################
#
# gensio
#
################################################################################

GENSIO_VERSION = 1.3.3
GENSIO_SITE = http://downloads.sourceforge.net/project/ser2net/ser2net
GENSIO_LICENSE = LGPL-2.1+ (library), GPL-2.0+ (tools)
GENSIO_LICENSE_FILES = COPYING.LIB COPYING
GENSIO_INSTALL_STAGING = YES
GENSIO_CONF_OPTS = \
	--without-openipmi \
	--without-swig \
	--without-python

# configure script by default searches host paths for openssl,
# breaking cross compilation. Disable this by explicitly pointing it
# at STAGING_DIR no matter if we have openssl enabled or not as it
# will correctly disable openssl support if not found there
GENSIO_CONF_OPTS += --with-openssl=$(STAGING_DIR)/usr

ifeq ($(BR2_PACKAGE_OPENSSL),y)
GENSIO_DEPENDENCIES += openssl
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
GENSIO_CONF_OPTS += --with-pthreads
else
GENSIO_CONF_OPTS += --without-pthreads
endif

$(eval $(autotools-package))
