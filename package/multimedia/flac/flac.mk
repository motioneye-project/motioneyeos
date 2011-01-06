################################################################################
#
# flac
#
################################################################################

FLAC_VERSION = 1.2.1
FLAC_SOURCE = flac-$(FLAC_VERSION).tar.gz
FLAC_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/flac/
FLAC_INSTALL_STAGING = YES

FLAC_CONF_OPT = \
	--enable-shared \
	--disable-cpplibs \
	--disable-xmms-plugin

ifeq ($(BR2_PACKAGE_LIBOGG),y)
FLAC_CONF_OPT += --with-ogg=$(STAGING_DIR)/usr
FLAC_DEPENDENCIES = libogg
else
FLAC_CONF_OPT += --disable-ogg
endif

$(eval $(call AUTOTARGETS,package/multimedia,flac))
