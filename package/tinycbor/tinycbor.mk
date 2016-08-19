################################################################################
#
# tinycbor
#
################################################################################

TINYCBOR_VERSION = v0.3.2
TINYCBOR_SITE = $(call github,01org,tinycbor,$(TINYCBOR_VERSION))
TINYCBOR_LICENSE = MIT
TINYCBOR_LICENSE_FILES = LICENSE

# This patch fixes the issue on unnamed union which are not supported by some
# targets like blackfin
# This patch is currently in dev branch and will be a part of v0.4
TINYCBOR_PATCH = \
	https://github.com/01org/tinycbor/commit/ede7f1431ae06c9086f2a83a57bd7832d99280e3.patch

TINYCBOR_DEPENDENCIES = host-pkgconf
TINYCBOR_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_CJSON),y)
TINYCBOR_DEPENDENCIES += cjson
endif

TINYCBOR_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS) V=1

define TINYCBOR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TINYCBOR_MAKE_OPTS) -C $(@D)
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
