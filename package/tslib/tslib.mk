################################################################################
#
# tslib
#
################################################################################

TSLIB_VERSION = 158ee49b32f83cb7b02d5315f41c2e4cff38942d
TSLIB_SITE = http://github.com/kergoth/tslib/tarball/$(TSLIB_VERSION)
TSLIB_LICENSE = GPL, LGPL
TSLIB_LICENSE_FILES = COPYING

TSLIB_AUTORECONF = YES
TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

$(eval $(autotools-package))
