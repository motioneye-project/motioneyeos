################################################################################
#
# mongrel2
#
################################################################################

MONGREL2_VERSION = v1.8.0
MONGREL2_SITE = $(call github,zedshaw,mongrel2,$(MONGREL2_VERSION))
MONGREL2_LICENSE = BSD-3c
MONGREL2_LICENSE_FILES = LICENSE
MONGREL2_DEPENDENCIES = sqlite zeromq

define MONGREL2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		PREFIX=/usr all
endef

define MONGREL2_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		PREFIX=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
