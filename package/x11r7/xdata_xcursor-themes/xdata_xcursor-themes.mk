################################################################################
#
# xdata_xcursor-themes
#
################################################################################

XDATA_XCURSOR_THEMES_VERSION = 1.0.3
XDATA_XCURSOR_THEMES_SOURCE = xcursor-themes-$(XDATA_XCURSOR_THEMES_VERSION).tar.bz2
XDATA_XCURSOR_THEMES_SITE = http://xorg.freedesktop.org/releases/individual/data
XDATA_XCURSOR_THEMES_LICENSE = MIT
XDATA_XCURSOR_THEMES_LICENSE_FILES = COPYING

XDATA_XCURSOR_THEMES_INSTALL_STAGING = YES
XDATA_XCURSOR_THEMES_DEPENDENCIES = xlib_libXcursor host-xapp_xcursorgen

$(eval $(autotools-package))
