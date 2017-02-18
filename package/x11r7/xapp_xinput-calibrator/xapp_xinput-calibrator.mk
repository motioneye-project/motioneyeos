################################################################################
#
# xapp_xinput-calibrator
#
################################################################################

XAPP_XINPUT_CALIBRATOR_VERSION = 0.7.5
XAPP_XINPUT_CALIBRATOR_SOURCE = xinput_calibrator-$(XAPP_XINPUT_CALIBRATOR_VERSION).tar.gz
XAPP_XINPUT_CALIBRATOR_SITE = http://github.com/downloads/tias/xinput_calibrator
XAPP_XINPUT_CALIBRATOR_LICENSE = MIT
XAPP_XINPUT_CALIBRATOR_LICENSE_FILES = COPYING
XAPP_XINPUT_CALIBRATOR_DEPENDENCIES = xlib_libX11 xlib_libXi

$(eval $(autotools-package))
