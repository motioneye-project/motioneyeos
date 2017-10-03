################################################################################
#
# jose
#
################################################################################

JOSE_VERSION = 10
JOSE_SOURCE = jose-$(JOSE_VERSION).tar.bz2
JOSE_SITE = https://github.com/latchset/jose/releases/download/v$(JOSE_VERSION)
JOSE_LICENSE = Apache-2.0
JOSE_LICENSE_FILES = COPYING
JOSE_INSTALL_STAGING = YES
JOSE_DEPENDENCIES = host-pkgconf zlib jansson openssl

$(eval $(autotools-package))
