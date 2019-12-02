################################################################################
#
# tinycbor
#
################################################################################

TINYCBOR_VERSION = 0.5.3
TINYCBOR_SITE = $(call github,intel,tinycbor,v$(TINYCBOR_VERSION))
TINYCBOR_LICENSE = MIT
TINYCBOR_LICENSE_FILES = LICENSE

TINYCBOR_DEPENDENCIES = host-pkgconf
TINYCBOR_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_CJSON),y)
TINYCBOR_DEPENDENCIES += cjson
endif

TINYCBOR_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS) V=1

ifeq ($(BR2_STATIC_LIBS),y)
TINYCBOR_MAKE_OPTS += BUILD_STATIC=1 BUILD_SHARED=0
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
TINYCBOR_MAKE_OPTS += BUILD_STATIC=1 BUILD_SHARED=1
else ifeq ($(BR2_SHARED_LIBS),y)
TINYCBOR_MAKE_OPTS += BUILD_STATIC=0 BUILD_SHARED=1
endif

# disabled parallel build because of build failures while
# producing the .config file
define TINYCBOR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TINYCBOR_MAKE_OPTS) -C $(@D)
endef

define TINYCBOR_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TINYCBOR_MAKE_OPTS) -C $(@D) \
		DESTDIR=$(STAGING_DIR) prefix=/usr install
endef

define TINYCBOR_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TINYCBOR_MAKE_OPTS) -C $(@D) \
		DESTDIR=$(TARGET_DIR) prefix=/usr install
endef

$(eval $(generic-package))
