################################################################################
#
# mcrypt
#
################################################################################

MCRYPT_VERSION = 2.6.8
MCRYPT_SITE = http://downloads.sourceforge.net/project/mcrypt/MCrypt/$(MCRYPT_VERSION)
MCRYPT_DEPENDENCIES = libmcrypt libmhash \
	$(if $(BR2_PACKAGE_ZLIB),zlib) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv) \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
MCRYPT_CONF_OPTS = --with-libmcrypt-prefix=$(STAGING_DIR)/usr
MCRYPT_LICENSE = GPLv3
MCRYPT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
