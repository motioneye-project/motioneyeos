################################################################################
#
# xapp_xedit
#
################################################################################

XAPP_XEDIT_VERSION = 1.2.2
XAPP_XEDIT_SOURCE = xedit-$(XAPP_XEDIT_VERSION).tar.bz2
XAPP_XEDIT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XEDIT_LICENSE = MIT
XAPP_XEDIT_LICENSE_FILES = COPYING
XAPP_XEDIT_DEPENDENCIES = xlib_libXaw

XAPP_XEDIT_CONF_OPTS = \
	--disable-selective-werror \
	--with-appdefaultdir=/usr/share/X11/app-defaults

$(eval $(autotools-package))
