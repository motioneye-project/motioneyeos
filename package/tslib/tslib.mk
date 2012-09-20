#############################################################
#
# tslib
#
#############################################################
TSLIB_VERSION = 412d99d
TSLIB_SITE = http://github.com/kergoth/tslib/tarball/master
TSLIB_AUTORECONF = YES
TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

$(eval $(autotools-package))
