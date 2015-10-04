################################################################################
#
# bridge-utils
#
################################################################################

BRIDGE_UTILS_VERSION = 1.5
BRIDGE_UTILS_SITE = http://downloads.sourceforge.net/project/bridge/bridge
BRIDGE_UTILS_AUTORECONF = YES
BRIDGE_UTILS_CONF_OPTS = --with-linux-headers=$(LINUX_HEADERS_DIR)
BRIDGE_UTILS_LICENSE = GPLv2+
BRIDGE_UTILS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
