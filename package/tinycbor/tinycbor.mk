################################################################################
#
# tinycbor
#
################################################################################

TINYCBOR_VERSION = v0.4.1
TINYCBOR_SITE = $(call github,01org,tinycbor,$(TINYCBOR_VERSION))
TINYCBOR_LICENSE = MIT
TINYCBOR_LICENSE_FILES = LICENSE

TINYCBOR_DEPENDENCIES = host-pkgconf
TINYCBOR_INSTALL_STAGING = YES

# This patch fixes static build of json2cbor
TINYCBOR_PATCH = \
	https://github.com/01org/tinycbor/commit/ae608ea2735bd331ec7dcf9d89928c38f0e0c981.patch

ifeq ($(BR2_PACKAGE_CJSON),y)
TINYCBOR_DEPENDENCIES += cjson
endif

TINYCBOR_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS) V=1

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
