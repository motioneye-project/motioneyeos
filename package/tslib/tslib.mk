#############################################################
#
# tslib
#
#############################################################
TSLIB_VERSION:=412d99d8b92c
TSLIB_SITE:=git://github.com/kergoth/tslib.git
TSLIB_AUTORECONF = YES
TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_TARGET = YES
TSLIB_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

TSLIB_CONF_OPT = \
	--prefix=/usr	\
	--sysconfdir=/etc

$(eval $(call AUTOTARGETS,package,tslib))
