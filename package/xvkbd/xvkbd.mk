#############################################################
#
# xvkbd
#
#############################################################
XVKBD_VERSION = 3.2
XVKBD_SOURCE = xvkbd-$(XVKBD_VERSION).tar.gz
XVKBD_SITE = http://homepage3.nifty.com/tsato/xvkbd

XVKBD_MAKE_OPT = CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" LD="$(TARGET_CC)" \
				CFLAGS="-O2 -I$(STAGING_DIR)/usr/include" USRLIBDIR="$(STAGING_DIR)/usr/lib"

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

