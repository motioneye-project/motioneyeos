################################################################################
#
# tinc
#
################################################################################

TINC_VERSION = 1.0.24
TINC_SITE = http://www.tinc-vpn.org/packages
TINC_DEPENDENCIES = lzo openssl zlib
TINC_LICENSE = GPLv2+ with OpenSSL exception
TINC_LICENSE_FILES = COPYING COPYING.README
TINC_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -std=c99"

$(eval $(autotools-package))
