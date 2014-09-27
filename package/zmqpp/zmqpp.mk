################################################################################
#
# zmqpp
#
################################################################################

ZMQPP_VERSION = 36413487f05b165dfc82ad307a5a1c36a795e607
ZMQPP_SITE = $(call github,benjamg,zmqpp,$(ZMQPP_VERSION))
ZMQPP_INSTALL_STAGING = YES
ZMQPP_DEPENDENCIES = zeromq
ZMQPP_LICENSE = LGPLv3+ with exceptions
ZMQPP_LICENSE_FILES = COPYING COPYING.LESSER

ZMQPP_MAKE_OPTS = LD="$(TARGET_CXX)" BUILD_PATH=./build PREFIX=/usr
ZMQPP_LDFLAGS = $(TARGET_LDFLAGS) -lpthread

ifeq ($(BR2_PACKAGE_ZMQPP_CLIENT),y)
ZMQPP_DEPENDENCIES += boost
endif

define ZMQPP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		LDFLAGS="$(ZMQPP_LDFLAGS)" \
		$(ZMQPP_MAKE_OPTS) $(if $(BR2_PACKAGE_ZMQPP_CLIENT),all) -C $(@D)
endef

define ZMQPP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/usr/include/zmqpp
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(ZMQPP_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install -C $(@D)
endef

define ZMQPP_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/include/zmqpp
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		$(ZMQPP_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install -C $(@D)
endef

$(eval $(generic-package))
