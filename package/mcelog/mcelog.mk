################################################################################
#
# mcelog
#
################################################################################

MCELOG_VERSION = v153
MCELOG_SITE = $(BR2_KERNEL_MIRROR)/scm/utils/cpu/mce/mcelog.git
MCELOG_SITE_METHOD = git
MCELOG_LICENSE = GPL-2.0
MCELOG_LICENSE_FILES = README.md

define MCELOG_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define MCELOG_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
