################################################################################
#
# kvazaar
#
################################################################################

KVAZAAR_VERSION = v1.2.0
KVAZAAR_SITE = $(call github,ultravideo,kvazaar,$(KVAZAAR_VERSION))
KVAZAAR_LICENSE = LGPL-2.1+
KVAZAAR_LICENSE_FILES = COPYING
KVAZAAR_AUTORECONF = YES
KVAZAAR_INSTALL_STAGING = YES
KVAZAAR_DEPENDENCIES = host-pkgconf
KVAZAAR_CONF_OPTS = --without-cryptopp

$(eval $(autotools-package))
