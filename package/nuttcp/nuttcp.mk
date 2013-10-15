################################################################################
#
# nuttcp
#
################################################################################

NUTTCP_VERSION = 6.1.2
NUTTCP_SITE = http://www.lcp.nrl.navy.mil/nuttcp/
NUTTCP_SOURCE = nuttcp-$(NUTTCP_VERSION).tar.bz2
NUTTCP_LICENSE = GPLv2
NUTTCP_LICENSE_FILES = LICENSE

define NUTTCP_BUILD_CMDS
	$(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) all
endef

define NUTTCP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/nuttcp-$(NUTTCP_VERSION) \
		$(TARGET_DIR)/usr/bin/nuttcp
endef

define NUTTCP_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/nuttcp
endef

$(eval $(generic-package))
