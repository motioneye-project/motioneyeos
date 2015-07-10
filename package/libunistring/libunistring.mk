################################################################################
#
# libunistring
#
################################################################################

LIBUNISTRING_VERSION = 0.9.6
LIBUNISTRING_SITE = $(BR2_GNU_MIRROR)/libunistring
LIBUNISTRING_SOURCE = libunistring-$(LIBUNISTRING_VERSION).tar.xz
LIBUNISTRING_INSTALL_STAGING = YES
LIBUNISTRING_LICENSE = LGPLv3+
LIBUNISTRING_LICENSE_FILES = COPYING.LIB

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBUNISTRING_CONF_OPTS += --enable-threads=posix
else
LIBUNISTRING_CONF_OPTS += --disable-threads
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
