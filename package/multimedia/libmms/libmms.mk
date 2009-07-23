#############################################################
#
# libmms
#
#############################################################
LIBMMS_VERSION = 0.4
LIBMMS_SOURCE = libmms-$(LIBMMS_VERSION).tar.gz
LIBMMS_SITE = http://launchpad.net/libmms/trunk/$(LIBMMS_VERSION)/+download

LIBMMS_AUTORECONF = NO
LIBMMS_LIBTOOL_PATCH = NO
LIBMMS_INSTALL_STAGING = YES
LIBMMS_INSTALL_TARGET = YES

LIBMMS_DEPENDENCIES = uclibc host-pkgconfig libglib2

$(eval $(call AUTOTARGETS,package/multimedia,libmms))
