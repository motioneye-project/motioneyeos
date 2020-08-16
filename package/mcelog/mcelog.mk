################################################################################
#
# mcelog
#
################################################################################

MCELOG_VERSION = 168
MCELOG_SITE = $(call github,andikleen,mcelog,v$(MCELOG_VERSION))
MCELOG_LICENSE = GPL-2.0
MCELOG_LICENSE_FILES = LICENSE

define MCELOG_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define MCELOG_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
