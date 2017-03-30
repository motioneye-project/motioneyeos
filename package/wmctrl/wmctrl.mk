################################################################################
#
# wmctrl
#
################################################################################

WMCTRL_VERSION = 1.07
WMCTRL_SITE = https://sites.google.com/site/tstyblo/wmctrl
WMCTRL_LICENSE = GPL-2.0+
WMCTRL_LICENSE_FILES = COPYING

WMCTRL_DEPENDENCIES = libglib2 xlib_libX11 xlib_libXmu

$(eval $(autotools-package))
