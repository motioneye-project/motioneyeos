################################################################################
#
# rsync
#
################################################################################

RSYNC_VERSION = 3.1.0
RSYNC_SITE = http://rsync.samba.org/ftp/rsync/src
RSYNC_LICENSE = GPLv3+
RSYNC_LICENSE_FILES = COPYING
RSYNC_DEPENDENCIES = zlib popt
RSYNC_CONF_OPT = \
	$(if $(BR2_ENABLE_DEBUG),--enable-debug,--disable-debug) \
	--with-included-zlib=no \
	--with-included-popt=no

ifeq ($(BR2_PACKAGE_ACL),y)
	RSYNC_DEPENDENCIES += acl
else
	RSYNC_CONF_OPT += --disable-acl-support
endif

$(eval $(autotools-package))
