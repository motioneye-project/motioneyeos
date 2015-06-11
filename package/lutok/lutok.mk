################################################################################
#
# lutok
#
################################################################################

LUTOK_VERSION = 0.4
LUTOK_SITE = https://github.com/jmmv/lutok/releases/download/lutok-$(LUTOK_VERSION)
LUTOK_INSTALL_STAGING = YES
LUTOK_DEPENDENCIES = host-pkgconf lua
# --without-atf disables the atf-based lutok tests
LUTOK_CONF_OPTS = --without-doxygen --without-atf
LUTOK_LICENSE = BSD-3c
LUTOK_LICENSE_FILES = COPYING

$(eval $(autotools-package))
