################################################################################
#
# tslib
#
################################################################################

TSLIB_VERSION = 1.4
TSLIB_SITE = https://github.com/kergoth/tslib/releases/download/$(TSLIB_VERSION)
TSLIB_SOURCE = tslib-$(TSLIB_VERSION).tar.xz
TSLIB_LICENSE = GPL, LGPL
TSLIB_LICENSE_FILES = COPYING

TSLIB_PATCH = https://github.com/kergoth/tslib/commit/02795c4fa8b842c6fc017e86b5e036466bd4d3ef.patch
TSLIB_AUTORECONF = YES
TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

ifeq ($(BR2_TOOLCHAIN_HEADERS_AT_LEAST_3_6),)
TSLIB_CONF_OPTS += --disable-tools
endif

$(eval $(autotools-package))
