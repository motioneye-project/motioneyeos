################################################################################
#
# xapp_sessreg -- manage utmp/wtmp entries for non-init clients
#
################################################################################

XAPP_SESSREG_VERSION = 1.0.2
XAPP_SESSREG_SOURCE = sessreg-$(XAPP_SESSREG_VERSION).tar.bz2
XAPP_SESSREG_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_SESSREG_AUTORECONF = YES
XAPP_SESSREG_DEPENDANCIES = xlib_libX11 xproto_xproto

$(eval $(call AUTOTARGETS,xapp_sessreg))
