#############################################################
#
# libogg
#
#############################################################
LIBOGG_VERSION = 1.1.3
LIBOGG_SOURCE = libogg-$(LIBOGG_VERSION).tar.gz
LIBOGG_SITE = http://downloads.xiph.org/releases/ogg
LIBOGG_AUTORECONF = NO
LIBOGG_INSTALL_STAGING = YES
LIBOGG_INSTALL_TARGET = YES

LIBOGG_DEPENDENCIES = uclibc pkgconfig

$(eval $(call AUTOTARGETS,package/audio,libogg))
