################################################################################
#
# zmqpp
#
################################################################################

ZMQPP_VERSION = 3.2.0
ZMQPP_SITE = $(call github,zeromq,zmqpp,$(ZMQPP_VERSION))
ZMQPP_INSTALL_STAGING = YES
ZMQPP_DEPENDENCIES = zeromq
ZMQPP_LICENSE = MIT
ZMQPP_LICENSE_FILES = LICENSE
ZMQPP_PATCH = https://github.com/zeromq/zmqpp/commit/260a9304f6c74272bd3c396f6cca685657b4aff1.patch

ZMQPP_MAKE_OPTS = LD="$(TARGET_CXX)" BUILD_PATH=./build PREFIX=/usr
ZMQPP_LDFLAGS = $(TARGET_LDFLAGS) -lpthread

ifeq ($(BR2_PACKAGE_ZMQPP_CLIENT),y)
ZMQPP_DEPENDENCIES += boost
endif

ifeq ($(BR2_STATIC_LIBS),y)
ZMQPP_MAKE_OPTS += BUILD_STATIC=yes BUILD_SHARED=no
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
ZMQPP_MAKE_OPTS += BUILD_STATIC=yes BUILD_SHARED=yes
else ifeq ($(BR2_SHARED_LIBS),y)
ZMQPP_MAKE_OPTS += BUILD_STATIC=no BUILD_SHARED=yes
endif

define ZMQPP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		LDFLAGS="$(ZMQPP_LDFLAGS)" \
		$(ZMQPP_MAKE_OPTS) $(if $(BR2_PACKAGE_ZMQPP_CLIENT),client,library) -C $(@D)
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
