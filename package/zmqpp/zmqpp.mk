################################################################################
#
# zmqpp
#
################################################################################

ZMQPP_VERSION = 31220ca
ZMQPP_SITE = git://github.com/benjamg/zmqpp.git
ZMQPP_INSTALL_STAGING = YES
ZMQPP_DEPENDENCIES = zeromq
ZMQPP_LICENSE = MIT
ZMQPP_LICENSE_FILES = LICENSE

ZMQPP_MAKE_OPT = LD="$(TARGET_CXX)" BUILD_PATH=./build PREFIX=/usr

ifeq ($(BR2_PACKAGE_ZMQPP_CLIENT),y)
ZMQPP_DEPENDENCIES += boost
endif

define ZMQPP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(ZMQPP_MAKE_OPT) $(if $(BR2_PACKAGE_ZMQPP_CLIENT),all) -C $(@D)
endef

define ZMQPP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/usr/include/zmqpp
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(ZMQPP_MAKE_OPT) DESTDIR=$(TARGET_DIR) install -C $(@D)
endef

define ZMQPP_UNINSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(ZMQPP_MAKE_OPT) DESTDIR=$(TARGET_DIR) uninstall -C $(@D)
	$(RM) $(TARGET_DIR)/usr/include/zmqpp
endef

define ZMQPP_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/include/zmqpp
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(ZMQPP_MAKE_OPT) DESTDIR=$(STAGING_DIR) install -C $(@D)
endef

define ZMQPP_UNINSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(ZMQPP_MAKE_OPT) DESTDIR=$(STAGING_DIR) uninstall -C $(@D)
	$(RM) $(STAGING_DIR)/usr/include/zmqpp
endef

define ZMQPP_CLEAN_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) $(ZMQPP_MAKE_OPT) \
		clean -C $(@D)
endef

$(eval $(generic-package))
