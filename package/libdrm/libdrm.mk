#############################################################
#
# libdrm
#
#############################################################
LIBDRM_VERSION = 2.4.11
LIBDRM_SOURCE = libdrm-$(LIBDRM_VERSION).tar.bz2
LIBDRM_SITE = http://dri.freedesktop.org/libdrm/
LIBDRM_AUTORECONF = NO
LIBDRM_LIBTOOL_PATCH = NO
LIBDRM_INSTALL_STAGING = YES
LIBDRM_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package,libdrm))
