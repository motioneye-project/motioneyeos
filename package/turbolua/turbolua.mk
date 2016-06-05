################################################################################
#
# turbolua
#
################################################################################

TURBOLUA_VERSION = 6fbc5cbfed1cc8c3820d4c1bfb55258c764040f0
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
	$(MAKE) $(TURBOLUA_MAKE_OPTS) -C $(@D) all
endef

define TURBOLUA_INSTALL_TARGET_CMDS
	$(MAKE) $(TURBOLUA_MAKE_OPTS) LDCONFIG=true \
		PREFIX="$(TARGET_DIR)/usr" -C $(@D) install
endef

$(eval $(generic-package))
