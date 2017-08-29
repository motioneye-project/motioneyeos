################################################################################
#
# tslib
#
################################################################################

TSLIB_VERSION = 1.12
TSLIB_SITE = https://github.com/kergoth/tslib/releases/download/$(TSLIB_VERSION)
TSLIB_SOURCE = tslib-$(TSLIB_VERSION).tar.xz
TSLIB_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (libraries)
TSLIB_LICENSE_FILES = COPYING

TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

ifeq ($(BR2_TOOLCHAIN_HEADERS_AT_LEAST_3_6),)
TSLIB_CONF_OPTS += --disable-tools
endif

ifeq ($(BR2_STATIC_LIBS),y)
TSLIB_CONF_OPTS += \
	--enable-input=static \
	--enable-linear=static \
	--enable-median=static \
	--enable-pthres=static \
	--enable-iir=static \
	--enable-dejitter=static \
	--enable-debounce=static \
	--enable-skip=static
endif

$(eval $(autotools-package))
