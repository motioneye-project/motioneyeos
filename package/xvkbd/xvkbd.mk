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

XVKBD_DEPENDENCIES = xserver_xorg-server xlib_libXaw xlib_libXtst

$(eval $(autotools-package))

