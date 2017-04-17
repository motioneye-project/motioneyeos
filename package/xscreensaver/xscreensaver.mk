################################################################################
#
# xscreensaver
#
################################################################################

XSCREENSAVER_VERSION = 5.32
XSCREENSAVER_SITE = http://www.jwz.org/xscreensaver

# N.B. GPL-2.0+ code (in the hacks/glx subdirectory) is not currently built.
XSCREENSAVER_LICENSE = MIT-like, GPL-2.0+
XSCREENSAVER_LICENSE_FILES = hacks/screenhack.h hacks/glx/chessmodels.h

XSCREENSAVER_DEPENDENCIES = jpeg libglade libgtk2 xlib_libX11 xlib_libXt \
	$(if $(BR2_PACKAGE_GETTEXT),gettext) host-intltool

# otherwise we end up with host include/library dirs passed to the
# compiler/linker
XSCREENSAVER_CONF_OPTS = \
	--includedir=$(STAGING_DIR)/usr/include \
	--libdir=$(STAGING_DIR)/usr/lib

XSCREENSAVER_INSTALL_TARGET_OPTS = install_prefix="$(TARGET_DIR)" install

$(eval $(autotools-package))
