################################################################################
#
# mcelog
#
################################################################################

MCELOG_VERSION = v109
MCELOG_SITE = $(BR2_KERNEL_MIRROR)/scm/utils/cpu/mce/mcelog.git
MCELOG_SITE_METHOD = git
MCELOG_LICENSE = GPLv2
MCELOG_LICENSE_FILES = README

define MCELOG_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define MCELOG_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
