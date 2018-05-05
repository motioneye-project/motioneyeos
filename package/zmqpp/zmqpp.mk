################################################################################
#
# zmqpp
#
################################################################################

ZMQPP_VERSION = 4.1.2
ZMQPP_SITE = $(call github,zeromq,zmqpp,$(ZMQPP_VERSION))
ZMQPP_INSTALL_STAGING = YES
ZMQPP_DEPENDENCIES = zeromq
ZMQPP_LICENSE = MPL-2.0
ZMQPP_LICENSE_FILES = LICENSE
ZMQPP_MAKE_OPTS = LD="$(TARGET_CXX)" BUILD_PATH=./build PREFIX=/usr
ZMQPP_LDFLAGS = $(TARGET_LDFLAGS) -lpthread
ZMQPP_CONFIG = $(if $(BR2_ENABLE_DEBUG),debug,release)

# gcc bug internal compiler error: in merge_overlapping_regs, at
# regrename.c:304. This bug is fixed since gcc 6.
# By setting CONFIG to empty, all optimizations such as -funroll-loops
# -ffast-math -finline-functions -fomit-frame-pointer are disabled
ifeq ($(BR2_or1k):$(BR2_TOOLCHAIN_GCC_AT_LEAST_6),y:)
ZMQPP_CONFIG =
endif

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
ZMQPP_LDFLAGS += -latomic
endif

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
		CONFIG=$(ZMQPP_CONFIG) LDFLAGS="$(ZMQPP_LDFLAGS)" \
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
