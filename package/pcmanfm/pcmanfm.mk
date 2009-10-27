#############################################################
#
# pcmanfm
#
#############################################################
PCMANFM_VERSION = 0.3.5.9
PCMANFM_SOURCE = pcmanfm-$(PCMANFM_VERSION).tar.gz
PCMANFM_SITE = http://internap.dl.sourceforge.net/sourceforge/pcmanfm
PCMANFM_AUTORECONF = NO
PCMANFM_INSTALL_STAGING = NO
PCMANFM_INSTALL_TARGET = YES

PCMANFM_CONF_OPT = --disable-hal

PCMANFM_DEPENDENCIES = host-pkg-config libgtk2 gamin startup-notification xserver_xorg-server

$(eval $(call AUTOTARGETS,package,pcmanfm))

