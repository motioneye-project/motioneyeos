################################################################################
#
# mmc-utils
#
################################################################################

MMC_UTILS_VERSION = d0b46442b50794217e53b2455c1344c548d9d088
MMC_UTILS_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git
MMC_UTILS_LICENSE = GPLv2

define MMC_UTILS_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define MMC_UTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mmc $(TARGET_DIR)/usr/bin/mmc
endef

$(eval $(generic-package))
