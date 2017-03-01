################################################################################
#
# turbolua
#
################################################################################

TURBOLUA_VERSION = v2.1.0
TURBOLUA_SITE = $(call github,kernelsauce,turbo,$(TURBOLUA_VERSION))
TURBOLUA_DEPENDENCIES = luajit
TURBOLUA_LICENSE = Apache-2.0
TURBOLUA_LICENSE_FILES = LICENSE

TURBOLUA_MAKE_OPTS = \
	$(TARGET_CONFIGURE_OPTS) \
	LUAJIT_VERSION="$(LUAJIT_VERSION)"

ifeq ($(BR2_PACKAGE_OPENSSL),y)
TURBOLUA_MAKE_OPTS += SSL=openssl
TURBOLUA_DEPENDENCIES += openssl
else
TURBOLUA_MAKE_OPTS += SSL=none
endif

define TURBOLUA_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TURBOLUA_MAKE_OPTS) -C $(@D) all
endef

define TURBOLUA_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TURBOLUA_MAKE_OPTS) LDCONFIG=true \
		PREFIX="$(TARGET_DIR)/usr" -C $(@D) install
endef

$(eval $(generic-package))
