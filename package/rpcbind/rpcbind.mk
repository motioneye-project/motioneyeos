################################################################################
#
# rpcbind
#
################################################################################

RPCBIND_VERSION = 0.2.0
RPCBIND_SITE    = http://downloads.sourceforge.net/project/rpcbind/rpcbind/$(RPCBIND_VERSION)
RPCBIND_SOURCE  = rpcbind-$(RPCBIND_VERSION).tar.bz2
RPCBIND_LICENSE = BSD-3c
RPCBIND_LICENSE_FILES = COPYING
RPCBIND_AUTORECONF = YES

RPCBIND_CONF_ENV += \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/tirpc/"
RPCBIND_DEPENDENCIES += libtirpc

$(eval $(autotools-package))
