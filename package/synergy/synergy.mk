#############################################################
#
# synergy
#
#############################################################

SYNERGY_VERSION = 1.3.1
SYNERGY_SOURCE = synergy-$(SYNERGY_VERSION).tar.gz
SYNERGY_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/synergy2/
SYNERGY_CONF_OPT = --x-includes=$(STAGING_DIR)/usr/include/X11 \
                   --x-libraries=$(STAGING_DIR)/usr/lib

SYNERGY_DEPENDENCIES = xserver_xorg-server xlib_libXtst

$(eval $(call AUTOTARGETS,package,synergy))
