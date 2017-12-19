################################################################################
#
# xvkbd
#
################################################################################

XVKBD_VERSION = 3.7
XVKBD_SITE = http://t-sato.in.coocan.jp/xvkbd
XVKBD_LICENSE = GPL-2.0+
XVKBD_LICENSE_FILES = README

# Passing USRLIBDIR ensures that the stupid Makefile doesn't add
# /usr/lib to the library search path.
define XVKBD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
		USRLIBDIR="$(STAGING_DIR)/usr/lib"
endef

define XVKBD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
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
