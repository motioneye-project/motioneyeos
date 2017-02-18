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

ifeq ($(BR2_arc),y)
TINC_CONF_ENV += \
	ax_cv_check_cflags___fPIE=no \
	ax_cv_check_ldflags___pie=no
endif

$(eval $(autotools-package))
