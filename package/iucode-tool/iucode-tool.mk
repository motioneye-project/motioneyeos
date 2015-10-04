################################################################################
#
# iucode-tool
#
################################################################################

IUCODE_TOOL_VERSION = 1cbd73013cd4c6b2b287f07f6189eef35cb83ca0
IUCODE_TOOL_SITE = git://gitorious.org/iucode-tool/iucode-tool.git
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
IUCODE_TOOL_CONF_ENV = LIBS="-largp"
IUCODE_TOOL_DEPENDENCIES = argp-standalone
endif
IUCODE_TOOL_AUTORECONF = YES
IUCODE_TOOL_LICENSE = GPLv2+
IUCODE_TOOL_LICENSE_FILES = COPYING

define IUCODE_TOOL_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/iucode-tool/S00iucode-tool \
		$(TARGET_DIR)/etc/init.d/S00iucode-tool
endef

$(eval $(autotools-package))
