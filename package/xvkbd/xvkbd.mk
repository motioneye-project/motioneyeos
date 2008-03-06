#############################################################
#
# xvkbd
#
#############################################################
XVKBD_VERSION = 2.8
XVKBD_SOURCE = xvkbd-$(XVKBD_VERSION).tar.gz
XVKBD_SITE = http://homepage3.nifty.com/tsato/xvkbd
XVKBD_AUTORECONF = NO
XVKBD_INSTALL_STAGING = NO
XVKBD_INSTALL_TARGET = YES

XVKBD_MAKE_OPT = CC=$(TARGET_CC) CXX=$(TARGET_CXX) LD=$(TARGET_CC) \
				CFLAGS="-O2 -I$(STAGING_DIR)/usr/include" USRLIBDIR="$(STAGING_DIR)/usr/lib"

XVKBD_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

XVKBD_DEPENDENCIES = uclibc $(XSERVER)

$(eval $(call AUTOTARGETS,package,xvkbd))

