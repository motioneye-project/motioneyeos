################################################################################
#
# xapp_xcalc -- scientific calculator for X
#
################################################################################

XAPP_XCALC_VERSION = 1.0.2
XAPP_XCALC_SOURCE = xcalc-$(XAPP_XCALC_VERSION).tar.bz2
XAPP_XCALC_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCALC_AUTORECONF = NO
XAPP_XCALC_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install-exec install-data
XAPP_XCALC_DEPENDENCIES = xlib_libXaw

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xcalc))
