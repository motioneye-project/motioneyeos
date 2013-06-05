################################################################################
#
# xdriver_xf86-input-tslib
#
################################################################################

XDRIVER_XF86_INPUT_TSLIB_VERSION = 0.0.6
XDRIVER_XF86_INPUT_TSLIB_SOURCE = xf86-input-tslib-$(XDRIVER_XF86_INPUT_TSLIB_VERSION).tar.bz2
XDRIVER_XF86_INPUT_TSLIB_SITE = http://www.ptxdist.org/software/xf86-input-tslib/download
XDRIVER_XF86_INPUT_TSLIB_LICENSE = MIT
XDRIVER_XF86_INPUT_TSLIB_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_TSLIB_DEPENDENCIES = \
	xproto_inputproto \
	xserver_xorg-server \
	xproto_randrproto \
	xproto_xproto \
	tslib

$(eval $(autotools-package))
