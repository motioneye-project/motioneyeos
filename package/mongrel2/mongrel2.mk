################################################################################
#
# mongrel2
#
################################################################################

MONGREL2_VERSION = 1.8.0
MONGREL2_SOURCE = mongrel2_$(MONGREL2_VERSION).tar.gz
MONGREL2_SITE = https://github.com/zedshaw/mongrel2/tarball/v$(MONGREL2_VERSION)
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

define MONGREL2_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/mongrel2
	rm -f $(TARGET_DIR)/usr/bin/m2sh
	rm -f $(TARGET_DIR)/usr/bin/procer
endef

$(eval $(generic-package))

