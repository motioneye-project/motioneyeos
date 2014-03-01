################################################################################
#
# libpthread-stubs
#
################################################################################

LIBPTHREAD_STUBS_VERSION = 0.3
LIBPTHREAD_STUBS_SOURCE = libpthread-stubs-$(LIBPTHREAD_STUBS_VERSION).tar.bz2
LIBPTHREAD_STUBS_SITE = http://xcb.freedesktop.org/dist/
LIBPTHREAD_STUBS_LICENSE = MIT
LIBPTHREAD_STUBS_LICENSE_FILES = COPYING

LIBPTHREAD_STUBS_INSTALL_STAGING = YES

ifeq ($(BR2_PREFER_STATIC_LIB),y)
LIBPTHREAD_STUBS_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) -pthread"
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
