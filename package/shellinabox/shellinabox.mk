################################################################################
#
# shellinabox
#
################################################################################

SHELLINABOX_VERSION = v2.19
SHELLINABOX_SITE = $(call github,shellinabox,shellinabox,$(SHELLINABOX_VERSION))
SHELLINABOX_LICENSE = GPLv2 with OpenSSL exception
SHELLINABOX_LICENSE_FILES = COPYING GPL-2

# Fetching from Github, and patching Makefile.am, so we need to autoreconf
SHELLINABOX_AUTORECONF = YES

# The OpenSSL support is supposed to be optional, but in practice,
# with OpenSSL disabled, it fails to build. See
# https://github.com/shellinabox/shellinabox/issues/385.
SHELLINABOX_DEPENDENCIES = zlib openssl
SHELLINABOX_CONF_OPTS = \
	--disable-runtime-loading \
	--enable-ssl

$(eval $(autotools-package))
