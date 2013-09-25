################################################################################
#
# rsync
#
################################################################################

RSYNC_VERSION = 3.1.0
RSYNC_SITE = http://rsync.samba.org/ftp/rsync/src
RSYNC_LICENSE = GPLv3+
RSYNC_LICENSE_FILES = COPYING
RSYNC_CONF_OPT = $(if $(BR2_ENABLE_DEBUG),--enable-debug,--disable-debug)
RSYNC_CONF_OPT = --with-included-popt

$(eval $(autotools-package))
