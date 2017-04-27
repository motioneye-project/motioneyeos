################################################################################
#
# tslib
#
################################################################################

TSLIB_VERSION = 1.9
TSLIB_SITE = https://github.com/kergoth/tslib/releases/download/$(TSLIB_VERSION)
TSLIB_SOURCE = tslib-$(TSLIB_VERSION).tar.xz
TSLIB_LICENSE = GPL, LGPL
TSLIB_LICENSE_FILES = COPYING

TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

ifeq ($(BR2_TOOLCHAIN_HEADERS_AT_LEAST_3_6),)
TSLIB_CONF_OPTS += --disable-tools
endif

$(eval $(autotools-package))
