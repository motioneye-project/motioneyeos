################################################################################
#
# libsexy
#
################################################################################

LIBSEXY_VERSION = 0.1.11
LIBSEXY_SOURCE = libsexy-$(LIBSEXY_VERSION).tar.gz
LIBSEXY_SITE = http://releases.chipx86.com/libsexy/libsexy/
LIBSEXY_AUTORECONF = NO
LIBSEXY_DEPENDENCIES = xlib_libX11 libgtk2
LIBSEXY_INSTALL_TARGET = YES
LIBSEXY_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package/libsexy,libsexy))
