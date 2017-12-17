################################################################################
#
# fxload
#
################################################################################

FXLOAD_VERSION = 2008_10_13
FXLOAD_SITE = http://downloads.sourceforge.net/project/linux-hotplug/fxload/$(FXLOAD_VERSION)
FXLOAD_LICENSE = GPL-2.0+
FXLOAD_LICENSE_FILES = COPYING

define FXLOAD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define FXLOAD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) prefix=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
