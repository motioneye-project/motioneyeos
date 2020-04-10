################################################################################
#
# subversion
#
################################################################################

SUBVERSION_VERSION = 1.13.0
SUBVERSION_SOURCE = subversion-$(SUBVERSION_VERSION).tar.bz2
SUBVERSION_SITE = https://downloads.apache.org/subversion
SUBVERSION_LICENSE = Apache-2.0
SUBVERSION_LICENSE_FILES = LICENSE
SUBVERSION_DEPENDENCIES = \
	host-pkgconf \
	apr \
	apr-util \
	expat \
	lz4 \
	utf8proc \
	zlib \
	sqlite \
	$(TARGET_NLS_DEPENDENCIES)
SUBVERSION_AUTORECONF = YES
SUBVERSION_CONF_OPTS = \
	--with-expat=$(STAGING_DIR)/usr/include:$(STAGING_DIR)/usr/lib: \
	--with-apr=$(STAGING_DIR)/usr \
	--with-apr-util=$(STAGING_DIR)/usr \
	--with-lz4=$(STAGING_DIR)/usr \
	--with-utf8proc=$(STAGING_DIR)/usr \
	--with-zlib=$(STAGING_DIR)/usr \
	--without-serf \
	--without-apxs \
	--without-berkeley-db \
	--without-sasl \
	--without-gnome-keyring \
	--without-libmagic
SUBVERSION_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)

$(eval $(autotools-package))
