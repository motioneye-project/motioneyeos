################################################################################
#
# subversion
#
################################################################################

SUBVERSION_VERSION = 1.7.18
SUBVERSION_SITE = http://archive.apache.org/dist/subversion
SUBVERSION_LICENSE = Apache-2.0
SUBVERSION_LICENSE_FILES = LICENSE

SUBVERSION_DEPENDENCIES = apr apr-util expat neon zlib
SUBVERSION_CONF_OPT = \
	--with-expat=$(STAGING_DIR)/usr/include:$(STAGING_DIR)/usr/lib: \
	--with-apr=$(STAGING_DIR)/usr \
	--with-apr-util=$(STAGING_DIR)/usr \
	--with-zlib=$(STAGING_DIR)/usr \
	--with-neon=$(STAGING_DIR)/usr \
	--without-gssapi \
	--without-serf \
	--without-apxs \
	--without-berkeyley-db \
	--without-sasl \
	--without-gnome-keyring \
	--without-ssl \
	--without-libmagic

$(eval $(autotools-package))
