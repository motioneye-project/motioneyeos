################################################################################
#
# libsodium
#
################################################################################

LIBSODIUM_VERSION = 1.0.16
LIBSODIUM_SITE = https://github.com/jedisct1/libsodium/releases/download/$(LIBSODIUM_VERSION)
LIBSODIUM_LICENSE = ISC
LIBSODIUM_LICENSE_FILES = LICENSE
LIBSODIUM_INSTALL_STAGING = YES

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
LIBSODIUM_CONF_OPTS += --disable-pie
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
