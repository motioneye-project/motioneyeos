################################################################################
#
# tslib
#
################################################################################

TSLIB_VERSION = 1.1
TSLIB_SITE = $(call github,kergoth,tslib,$(TSLIB_VERSION))
TSLIB_LICENSE = GPL, LGPL
TSLIB_LICENSE_FILES = COPYING

TSLIB_AUTORECONF = YES
TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

$(eval $(autotools-package))
