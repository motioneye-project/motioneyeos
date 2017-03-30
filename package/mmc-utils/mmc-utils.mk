################################################################################
#
# mmc-utils
#
################################################################################

MMC_UTILS_VERSION = 2cb6695e8dec00d887bdd5309d1b57d836fcd214
MMC_UTILS_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git
MMC_UTILS_LICENSE = GPL-2.0

define MMC_UTILS_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define MMC_UTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mmc $(TARGET_DIR)/usr/bin/mmc
endef

$(eval $(generic-package))
