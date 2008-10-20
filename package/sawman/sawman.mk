#############################################################
#
# SAWMAN
#
#############################################################
SAWMAN_VERSION:=1.2.0-rc1
SAWMAN_SOURCE:=SaWMan-$(SAWMAN_VERSION).tar.gz
SAWMAN_SITE:=http://www.directfb.org/downloads/Extras
SAWMAN_INSTALL_STAGING = YES
SAWMAN_INSTALL_TARGET = YES
SAWMAN_CONF_ENV = LDFLAGS="-L$(STAGING_DIR)/usr/lib -Wl,--rpath-link -Wl,$(STAGING_DIR)/usr/lib"
ifeq ($(BR2_ENABLE_DEBUG),y)
SAWMAN_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install
else
SAWMAN_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install-strip
endif
SAWMAN_DEPENDENCIES = directfb

$(eval $(call AUTOTARGETS,package,sawman))

