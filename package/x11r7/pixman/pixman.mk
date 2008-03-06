################################################################################
#
# pixman
#
################################################################################

PIXMAN_VERSION = 0.9.6
PIXMAN_SOURCE = pixman-$(PIXMAN_VERSION).tar.gz
PIXMAN_SITE = http://cairographics.org/releases/
PIXMAN_AUTORECONF = NO
PIXMAN_INSTALL_STAGING = YES
PIXMAN_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install install-data
PIXMAN_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install install-data

PIXMAN_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_dmxproto

$(eval $(call AUTOTARGETS,package/x11r7,pixman))
