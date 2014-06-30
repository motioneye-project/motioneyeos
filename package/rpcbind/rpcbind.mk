################################################################################
#
# rpcbind
#
################################################################################

RPCBIND_VERSION = 0.2.1
RPCBIND_SITE    = http://downloads.sourceforge.net/project/rpcbind/rpcbind/$(RPCBIND_VERSION)
RPCBIND_SOURCE  = rpcbind-$(RPCBIND_VERSION).tar.bz2
RPCBIND_LICENSE = BSD-3c
RPCBIND_LICENSE_FILES = COPYING
RPCBIND_AUTORECONF = YES

RPCBIND_CONF_ENV += \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/tirpc/"
RPCBIND_DEPENDENCIES += libtirpc
RPCBIND_CONF_OPT += --with-rpcuser=root

define RPCBIND_INSTALL_INIT_SYSV
	[ -f $(TARGET_DIR)/etc/init.d/S30rpcbind ] || \
		$(INSTALL) -m 0755 -D package/rpcbind/S30rpcbind \
			$(TARGET_DIR)/etc/init.d/S30rpcbind
endef

$(eval $(autotools-package))
