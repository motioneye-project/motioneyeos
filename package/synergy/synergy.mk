#############################################################
#
# synergy
#
#############################################################

SYNERGY_VERSION = 1.3.1
SYNERGY_SOURCE = synergy-$(SYNERGY_VERSION).tar.gz
SYNERGY_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/synergy2/
SYNERGY_AUTORECONF = NO
SYNERGY_INSTALL_STAGING = NO
SYNERGY_INSTALL_TARGET = YES

SYNERGY_DEPENDENCIES = xserver_xorg-server xlib_libXtst

$(eval $(call AUTOTARGETS,package,synergy))
