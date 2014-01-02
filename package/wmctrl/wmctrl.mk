################################################################################
#
# wmctrl
#
################################################################################

WMCTRL_VERSION = 1.07
WMCTRL_SITE = http://tomas.styblo.name/wmctrl/dist
WMCTRL_LICENSE = GPLv2+
WMCTRL_LICENSE_FILES = COPYING

WMCTRL_DEPENDENCIES = libglib2 xlib_libX11 xlib_libXmu

$(eval $(autotools-package))
