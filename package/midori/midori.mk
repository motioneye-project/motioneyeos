#############################################################
#
# midori
#
#############################################################

MIDORI_VERSION = 0.0.18
MIDORI_SOURCE = midori-$(MIDORI_VERSION).tar.gz
MIDORI_SITE = http://software.twotoasts.de/media/midori/
MIDORI_AUTORECONF = YES
MIDORI_INSTALL_STAGING = NO
MIDORI_INSTALL_TARGET = YES

MIDORI_DEPENDENCIES = host-pkg-config webkit libsexy xserver_xorg-server

$(eval $(call AUTOTARGETS,package,midori))
