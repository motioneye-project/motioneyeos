################################################################################
#
# xapp_xload
#
################################################################################

XAPP_XLOAD_VERSION = 1.1.3
XAPP_XLOAD_SOURCE = xload-$(XAPP_XLOAD_VERSION).tar.bz2
XAPP_XLOAD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XLOAD_LICENSE = MIT
XAPP_XLOAD_LICENSE_FILES = COPYING
XAPP_XLOAD_DEPENDENCIES = xlib_libXaw
XAPP_XLOAD_CONF_OPTS = --with-appdefaultdir=/usr/share/X11/app-defaults

ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
# musl doesn't have rwhod.h, but xload can replace it with stubs
XAPP_XLOAD_CONF_OPTS += CFLAGS="$(TARGET_CFLAGS) -DRLOADSTUB"
endif

$(eval $(autotools-package))
