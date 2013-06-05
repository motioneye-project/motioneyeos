################################################################################
#
# xvkbd
#
################################################################################

XVKBD_VERSION = 3.2
XVKBD_SOURCE = xvkbd-$(XVKBD_VERSION).tar.gz
XVKBD_SITE = http://homepage3.nifty.com/tsato/xvkbd

# Passing USRLIBDIR ensures that the stupid Makefile doesn't add
# /usr/lib to the library search path.
define XVKBD_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
		USRLIBDIR="$(STAGING_DIR)/usr/lib"
endef

define XVKBD_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

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

$(eval $(generic-package))

