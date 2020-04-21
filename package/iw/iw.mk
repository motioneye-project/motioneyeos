################################################################################
#
# iw
#
################################################################################

IW_VERSION = 5.4
IW_SOURCE = iw-$(IW_VERSION).tar.xz
IW_SITE = $(BR2_KERNEL_MIRROR)/software/network/iw
IW_LICENSE = ISC
IW_LICENSE_FILES = COPYING
IW_DEPENDENCIES = host-pkgconf libnl
IW_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	PKG_CONFIG="$(HOST_DIR)/bin/pkg-config"

define IW_BUILD_CMDS
	$(IW_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define IW_INSTALL_TARGET_CMDS
	$(IW_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
