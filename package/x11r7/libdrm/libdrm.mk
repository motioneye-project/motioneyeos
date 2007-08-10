#############################################################
#
# libdrm
#
#############################################################
LIBDRM_VERSION = 2.3.0
LIBDRM_SOURCE = libdrm-$(LIBDRM_VERSION).tar.bz2
LIBDRM_SITE = http://dri.freedesktop.org/libdrm/

LIBDRM_INSTALL_STAGING = YES

LIBDRM_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,libdrm))

