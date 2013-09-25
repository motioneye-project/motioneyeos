################################################################################
#
# flac
#
################################################################################

FLAC_VERSION = 1.2.1
FLAC_SITE = http://downloads.sourceforge.net/project/flac/flac-src/flac-$(FLAC_VERSION)-src
FLAC_INSTALL_STAGING = YES

FLAC_CONF_OPT = \
	--disable-cpplibs \
	--disable-xmms-plugin

ifeq ($(BR2_PACKAGE_LIBOGG),y)
FLAC_CONF_OPT += --with-ogg=$(STAGING_DIR)/usr
FLAC_DEPENDENCIES = libogg
else
FLAC_CONF_OPT += --disable-ogg
endif

$(eval $(autotools-package))
