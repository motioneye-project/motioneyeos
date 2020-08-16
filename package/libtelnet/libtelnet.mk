################################################################################
#
# libtelnet
#
################################################################################

LIBTELNET_VERSION = 0.23
LIBTELNET_SITE = https://github.com/seanmiddleditch/libtelnet/releases/download/$(LIBTELNET_VERSION)
LIBTELNET_INSTALL_STAGING = YES
LIBTELNET_CONF_OPTS = --disable-util
LIBTELNET_DEPENDENCIES = host-pkgconf
LIBTELNET_LICENSE = Public domain
LIBTELNET_LICENSE_FILES = COPYING

# for 0001-fix-compilation-without-zlib.patch
LIBTELNET_AUTORECONF = YES

$(eval $(autotools-package))
