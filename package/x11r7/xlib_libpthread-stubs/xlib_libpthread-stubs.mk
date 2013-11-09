################################################################################
#
# xlib_libpthread-stubs
#
################################################################################

XLIB_LIBPTHREAD_STUBS_VERSION = 0.3
XLIB_LIBPTHREAD_STUBS_SOURCE = libpthread-stubs-$(XLIB_LIBPTHREAD_STUBS_VERSION).tar.bz2
XLIB_LIBPTHREAD_STUBS_SITE = http://xcb.freedesktop.org/dist/
XLIB_LIBPTHREAD_STUBS_LICENSE = MIT
XLIB_LIBPTHREAD_STUBS_LICENSE_FILES = COPYING

XLIB_LIBPTHREAD_STUBS_INSTALL_STAGING = YES

ifeq ($(BR2_PREFER_STATIC_LIB),y)
XLIB_LIBPTHREAD_STUBS_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) -pthread"
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
