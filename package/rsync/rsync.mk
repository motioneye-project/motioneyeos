################################################################################
#
# rsync
#
################################################################################

RSYNC_VERSION = 3.1.2
RSYNC_SITE = http://rsync.samba.org/ftp/rsync/src
RSYNC_LICENSE = GPLv3+
RSYNC_LICENSE_FILES = COPYING
RSYNC_DEPENDENCIES = zlib popt
RSYNC_CONF_OPTS = \
	--with-included-zlib=no \
	--with-included-popt=no

ifeq ($(BR2_PACKAGE_ACL),y)
RSYNC_DEPENDENCIES += acl
else
RSYNC_CONF_OPTS += --disable-acl-support
endif

$(eval $(autotools-package))
