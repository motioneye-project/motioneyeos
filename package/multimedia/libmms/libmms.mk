#############################################################
#
# libmms
#
#############################################################
LIBMMS_VERSION = 0.6
LIBMMS_SOURCE = libmms-$(LIBMMS_VERSION).tar.gz
LIBMMS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libmms

LIBMMS_AUTORECONF = NO
LIBMMS_INSTALL_STAGING = YES
LIBMMS_INSTALL_TARGET = YES

LIBMMS_DEPENDENCIES = host-pkg-config libglib2

$(eval $(call AUTOTARGETS,package/multimedia,libmms))
