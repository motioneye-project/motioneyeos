################################################################################
#
# netcat
#
################################################################################

NETCAT_VERSION = 0.7.1
NETCAT_SITE = http://downloads.sourceforge.net/project/netcat/netcat/$(NETCAT_VERSION)
NETCAT_LICENSE = GPL-2.0+
NETCAT_LICENSE_FILES = COPYING

# Ensure Busybox gets built/installed before, so that this package
# overrides Busybox nc.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
NETCAT_DEPENDENCIES += busybox
endif

# Netcat doesn't overwrite a pre-existing 'nc' (e.g. from busybox) so
# force-remove it.
define NETCAT_RMOVE_NC_LINK
	rm -f $(TARGET_DIR)/usr/bin/nc
endef
NETCAT_PRE_INSTALL_TARGET_HOOKS += NETCAT_RMOVE_NC_LINK

$(eval $(autotools-package))
