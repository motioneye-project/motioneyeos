################################################################################
#
# bridge-utils
#
################################################################################

BRIDGE_UTILS_VERSION = 1.6
BRIDGE_UTILS_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/net/bridge-utils
BRIDGE_UTILS_SOURCE = bridge-utils-1.6.tar.xz
BRIDGE_UTILS_AUTORECONF = YES
BRIDGE_UTILS_LICENSE = GPL-2.0+
BRIDGE_UTILS_LICENSE_FILES = COPYING

# Avoid using the host's headers. Location is not important as
# required headers will anyway be found from within the sysroot.
BRIDGE_UTILS_CONF_OPTS = --with-linux-headers=$(STAGING_DIR)/usr/include

$(eval $(autotools-package))
