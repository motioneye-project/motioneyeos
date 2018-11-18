################################################################################
#
# axel
#
################################################################################

AXEL_VERSION = 2.16.1
AXEL_SITE = https://github.com/axel-download-accelerator/axel/releases/download/v$(AXEL_VERSION)
AXEL_SOURCE = axel-$(AXEL_VERSION).tar.xz
AXEL_LICENSE = GPL-2.0+
AXEL_LICENSE_FILES = COPYING
AXEL_DEPENDENCIES = host-pkgconf $(TARGET_NLS_DEPENDENCIES)

# ac_cv_prog_cc_c99 is required for BR2_USE_WCHAR=n because the C99 test
# provided by autoconf relies on wchar_t.
AXEL_CONF_OPTS = \
	ac_cv_prog_cc_c99=-std=c99 \
	CFLAGS="$(TARGET_CFLAGS)"

ifeq ($(BR2_PACKAGE_OPENSSL),y)
AXEL_CONF_OPTS += --with-ssl
AXEL_DEPENDENCIES += openssl
else
AXEL_CONF_OPTS += --without-ssl
endif

$(eval $(autotools-package))
