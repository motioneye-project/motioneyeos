################################################################################
#
# iucode-tool
#
################################################################################

IUCODE_TOOL_VERSION = 1.5
IUCODE_TOOL_SOURCE = iucode-tool_$(IUCODE_TOOL_VERSION).tar.xz
IUCODE_TOOL_SITE = https://gitlab.com/iucode-tool/releases/raw/master
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
IUCODE_TOOL_CONF_ENV = LIBS="-largp"
IUCODE_TOOL_DEPENDENCIES = argp-standalone
endif
IUCODE_TOOL_LICENSE = GPL-2.0+
IUCODE_TOOL_LICENSE_FILES = COPYING

define IUCODE_TOOL_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/iucode-tool/S00iucode-tool \
		$(TARGET_DIR)/etc/init.d/S00iucode-tool
endef

$(eval $(autotools-package))
