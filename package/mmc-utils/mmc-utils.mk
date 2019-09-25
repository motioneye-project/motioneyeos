################################################################################
#
# mmc-utils
#
################################################################################

MMC_UTILS_VERSION = d40ec535b9d4e4c974e8c2fbfb422cd0348cc5e8
MMC_UTILS_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git
MMC_UTILS_LICENSE = GPL-2.0
MMC_UTILS_LICENSE_FILES = mmc.h

define MMC_UTILS_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define MMC_UTILS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) prefix=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
