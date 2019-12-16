################################################################################
#
# iucode-tool
#
################################################################################

IUCODE_TOOL_VERSION = 2.3.1
IUCODE_TOOL_SOURCE = iucode-tool_$(IUCODE_TOOL_VERSION).tar.xz
IUCODE_TOOL_SITE = https://gitlab.com/iucode-tool/releases/raw/master
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
IUCODE_TOOL_DEPENDENCIES = argp-standalone
endif
IUCODE_TOOL_LICENSE = GPL-2.0+
IUCODE_TOOL_LICENSE_FILES = COPYING

define IUCODE_TOOL_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/iucode-tool/S00iucode-tool \
		$(TARGET_DIR)/etc/init.d/S00iucode-tool
endef

define IUCODE_TOOL_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/iucode-tool/iucode.service \
		$(TARGET_DIR)/usr/lib/systemd/system/iucode.service
endef

$(eval $(autotools-package))
