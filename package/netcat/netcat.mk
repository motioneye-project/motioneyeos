################################################################################
#
# netcat
#
################################################################################

NETCAT_VERSION = 0.7.1
NETCAT_SITE = http://downloads.sourceforge.net/project/netcat/netcat/$(NETCAT_VERSION)
NETCAT_LICENSE = GPL-2.0+
NETCAT_LICENSE_FILES = COPYING

# Ensure Busybox gets built/installed before, so that this package overrides
# Busybox nc.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
NETCAT_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
