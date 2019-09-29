################################################################################
#
# subversion
#
################################################################################

SUBVERSION_VERSION = 1.9.10
SUBVERSION_SOURCE = subversion-$(SUBVERSION_VERSION).tar.bz2
SUBVERSION_SITE = http://mirror.catn.com/pub/apache/subversion
SUBVERSION_LICENSE = Apache-2.0
SUBVERSION_LICENSE_FILES = LICENSE
SUBVERSION_DEPENDENCIES = host-pkgconf apr apr-util expat zlib sqlite
SUBVERSION_AUTORECONF = YES
SUBVERSION_CONF_OPTS = \
	--with-expat=$(STAGING_DIR)/usr/include:$(STAGING_DIR)/usr/lib: \
	--with-apr=$(STAGING_DIR)/usr \
	--with-apr-util=$(STAGING_DIR)/usr \
	--with-zlib=$(STAGING_DIR)/usr \
	--without-serf \
	--without-apxs \
	--without-berkeley-db \
	--without-sasl \
	--without-gnome-keyring \
	--without-libmagic

$(eval $(autotools-package))
