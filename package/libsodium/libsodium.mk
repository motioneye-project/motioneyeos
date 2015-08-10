################################################################################
#
# libsodium
#
################################################################################

LIBSODIUM_VERSION = 1.0.3
LIBSODIUM_SITE = https://github.com/jedisct1/libsodium/releases/download/$(LIBSODIUM_VERSION)
LIBSODIUM_LICENSE = ISC
LIBSODIUM_LICENSE_FILES = LICENSE
LIBSODIUM_INSTALL_STAGING = YES

ifeq ($(BR2_arc),y)
LIBSODIUM_CONF_OPTS += --disable-pie
endif

$(eval $(autotools-package))
