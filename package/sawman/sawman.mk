#############################################################
#
# SAWMAN
#
#############################################################
SAWMAN_VERSION:=1.4.10
SAWMAN_SOURCE:=SaWMan-$(SAWMAN_VERSION).tar.gz
SAWMAN_SITE:=http://www.directfb.org/downloads/Extras
SAWMAN_INSTALL_STAGING = YES
SAWMAN_INSTALL_TARGET = YES
# SAWMAN_CONF_ENV = LDFLAGS="-L$(STAGING_DIR)/usr/lib -Wl,--rpath-link -Wl,$(STAGING_DIR)/usr/lib"
SAWMAN_DEPENDENCIES = directfb

$(eval $(call AUTOTARGETS,package,sawman))

