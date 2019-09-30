################################################################################
#
# libsodium
#
################################################################################

LIBSODIUM_VERSION = 1.0.18
LIBSODIUM_SITE = https://download.libsodium.org/libsodium/releases
LIBSODIUM_LICENSE = ISC
LIBSODIUM_LICENSE_FILES = LICENSE
LIBSODIUM_INSTALL_STAGING = YES

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
LIBSODIUM_CONF_OPTS += --disable-pie
endif

ifeq ($(BR2_PACKAGE_LIBSODIUM_FULL),y)
LIBSODIUM_CONF_OPTS += --disable-minimal
else
LIBSODIUM_CONF_OPTS += --enable-minimal
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
