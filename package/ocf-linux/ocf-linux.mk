################################################################################
#
# ocf-linux
#
################################################################################

OCF_LINUX_VERSION = 20120127
OCF_LINUX_SITE = http://downloads.sourceforge.net/project/ocf-linux/ocf-linux/$(OCF_LINUX_VERSION)
OCF_LINUX_DEPENDENCIES = linux
OCF_LINUX_INSTALL_STAGING = YES

define OCF_LINUX_BUILD_CMDS
	$(MAKE) -C $(@D)/ocf $(LINUX_MAKE_FLAGS) KDIR=$(LINUX_DIR) \
		ocf_modules
endef

define OCF_LINUX_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/ocf $(LINUX_MAKE_FLAGS) KDIR=$(LINUX_DIR) \
		ocf_install
endef

define OCF_LINUX_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/ocf/cryptodev.h \
		$(STAGING_DIR)/usr/include/crypto/cryptodev.h
endef

$(eval $(generic-package))
