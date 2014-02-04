################################################################################
#
# iucode-tool
#
################################################################################

IUCODE_TOOL_VERSION = v1.0.1
IUCODE_TOOL_SITE = git://git.debian.org/users/hmh/iucode-tool.git
IUCODE_TOOL_AUTORECONF = YES
IUCODE_TOOL_LICENSE = GPLv2+
IUCODE_TOOL_LICENSE_FILES = COPYING

define IUCODE_TOOL_INSTALL_INIT_SYSV
	[ -f $(TARGET_DIR)/etc/init.d/S00iucode-tool ] || \
		$(INSTALL) -D -m 0755 package/iucode-tool/S00iucode-tool \
			$(TARGET_DIR)/etc/init.d/S00iucode-tool
endef

$(eval $(autotools-package))
