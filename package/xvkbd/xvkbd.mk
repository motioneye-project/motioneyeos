################################################################################
#
# xvkbd
#
################################################################################

XVKBD_VERSION = 4.0
XVKBD_SITE = http://t-sato.in.coocan.jp/xvkbd
XVKBD_LICENSE = GPL-2.0+
XVKBD_LICENSE_FILES = COPYING README
# We're patching Makefile.am
XVKBD_AUTORECONF = YES

XVKBD_DEPENDENCIES = \
	xlib_libICE \
	xlib_libSM \
	xlib_libX11 \
	xlib_libXaw \
	xlib_libXext \
	xlib_libXmu \
	xlib_libXpm \
	xlib_libXt \
	xlib_libXtst

$(eval $(autotools-package))
