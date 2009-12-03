#############################################################
#
# libvorbis
#
#############################################################

LIBVORBIS_VERSION = 1.2.3
LIBVORBIS_SOURCE = libvorbis-$(LIBVORBIS_VERSION).tar.gz
LIBVORBIS_SITE = http://downloads.xiph.org/releases/vorbis/$(LIBVORBIS-SOURCE)
LIBVORBIS_AUTORECONF = NO
LIBVORBIS_INSTALL_STAGING = YES
LIBVORBIS_INSTALL_TARGET = YES

LIBVORBIS_CONF_OPT = --disable-oggtest

LIBVORBIS_DEPENDENCIES = host-pkgconfig libogg

$(eval $(call AUTOTARGETS,package/multimedia,libvorbis))


############################################################
#
# Toplevel Makefile options
#
############################################################
ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
TARGETS+=libvorbis
endif
