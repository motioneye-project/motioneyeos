################################################################################
#
# bridge-utils
#
################################################################################

BRIDGE_UTILS_VERSION = 1.5
BRIDGE_UTILS_SITE = http://downloads.sourceforge.net/project/bridge/bridge
BRIDGE_UTILS_AUTORECONF = YES
BRIDGE_UTILS_CONF_OPT = --with-linux-headers=$(LINUX_HEADERS_DIR)
BRIDGE_UTILS_LICENSE = GPLv2+
BRIDGE_UTILS_LICENSE_FILES = COPYING

define BRIDGE_UTILS_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/,lib/libbridge.a \
		include/libbridge.h share/man/man8/brctl.8 sbin/brctl)
endef

$(eval $(autotools-package))
