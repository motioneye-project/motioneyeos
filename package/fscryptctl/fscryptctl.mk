################################################################################
#
# fscryptctl
#
################################################################################

FSCRYPTCTL_VERSION = 18428569e4b23cf33b90046aaed3b5fbdab3b191
FSCRYPTCTL_SITE = $(call github,google,fscryptctl,$(FSCRYPTCTL_VERSION))
FSCRYPTCTL_LICENSE = Apache-2.0
FSCRYPTCTL_LICENSE_FILES = LICENSE

define FSCRYPTCTL_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) fscryptctl
endef

define FSCRYPTCTL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/fscryptctl $(TARGET_DIR)/usr/bin/fscryptctl
endef

$(eval $(generic-package))
