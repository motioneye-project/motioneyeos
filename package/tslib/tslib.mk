#############################################################
#
# tslib
#
#############################################################
TSLIB_VERSION = 412d99d8b92c
TSLIB_SITE = git://github.com/kergoth/tslib.git
TSLIB_AUTORECONF = YES
TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

$(eval $(autotools-package))
