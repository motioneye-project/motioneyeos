################################################################################
#
# xapp_xcmsdb -- Device Color Characterization utility for X Color Management System
#
################################################################################

XAPP_XCMSDB_VERSION = 1.0.1
XAPP_XCMSDB_SOURCE = xcmsdb-$(XAPP_XCMSDB_VERSION).tar.bz2
XAPP_XCMSDB_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCMSDB_AUTORECONF = YES
XAPP_XCMSDB_DEPENDENCIES = xlib_libX11

$(eval $(call AUTOTARGETS,xapp_xcmsdb))
