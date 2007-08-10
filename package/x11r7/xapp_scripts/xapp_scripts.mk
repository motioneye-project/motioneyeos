################################################################################
#
# xapp_scripts -- start an X program on a remote machine
#
################################################################################

XAPP_SCRIPTS_VERSION = 1.0.1
XAPP_SCRIPTS_SOURCE = scripts-$(XAPP_SCRIPTS_VERSION).tar.bz2
XAPP_SCRIPTS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_SCRIPTS_AUTORECONF = YES
XAPP_SCRIPTS_DEPENDANCIES = xlib_libX11

$(eval $(call AUTOTARGETS,xapp_scripts))
