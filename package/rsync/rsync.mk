#############################################################
#
# rsync
#
#############################################################

RSYNC_VERSION := 3.0.8
RSYNC_SOURCE := rsync-$(RSYNC_VERSION).tar.gz
RSYNC_SITE := http://rsync.samba.org/ftp/rsync/src
RSYNC_INSTALL_STAGING = NO
RSYNC_CONF_OPT = $(if $(BR2_ENABLE_DEBUG),--enable-debug,--disable-debug)
RSYNC_CONF_OPT = --with-included-popt

$(eval $(call AUTOTARGETS,package,rsync))
