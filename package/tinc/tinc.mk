################################################################################
#
# tinc
#
################################################################################

TINC_VERSION = 1.0.36
TINC_SITE = http://www.tinc-vpn.org/packages
TINC_DEPENDENCIES = lzo openssl zlib
TINC_LICENSE = GPL-2.0+ with OpenSSL exception
TINC_LICENSE_FILES = COPYING COPYING.README
TINC_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -std=c99"

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
TINC_CONF_ENV += \
	ax_cv_check_cflags___fPIE=no \
	ax_cv_check_ldflags___pie=no
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
TINC_DEPENDENCIES += systemd
TINC_CONF_OPTS += --with-systemdsystemunitdir=/usr/lib/systemd/system
endif

$(eval $(autotools-package))
