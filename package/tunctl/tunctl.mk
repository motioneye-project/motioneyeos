################################################################################
#
# tunctl
#
################################################################################

TUNCTL_VERSION = 1.5
TUNCTL_SOURCE = tunctl-$(TUNCTL_VERSION).tar.gz
TUNCTL_SITE = http://downloads.sourceforge.net/project/tunctl/tunctl/$(TUNCTL_VERSION)

TUNCTL_LICENSE = GPLv2
TUNCTL_LICENSE_FILES = tunctl.c

define TUNCTL_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) tunctl
endef

define TUNCTL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/tunctl $(TARGET_DIR)/usr/sbin/tunctl
endef

$(eval $(generic-package))
