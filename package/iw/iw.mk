################################################################################
#
# iw
#
################################################################################

IW_VERSION = 4.9
IW_SOURCE = iw-$(IW_VERSION).tar.xz
IW_SITE = $(BR2_KERNEL_MIRROR)/software/network/iw
IW_LICENSE = ISC
IW_LICENSE_FILES = COPYING
IW_DEPENDENCIES = host-pkgconf libnl
IW_MAKE_OPTS = CC="$(TARGET_CC)" LD="$(TARGET_LD)" LDFLAGS="$(TARGET_LDFLAGS)"
IW_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	PKG_CONFIG="$(HOST_DIR)/bin/pkg-config" \
	GIT_DIR=$(IW_DIR)

define IW_BUILD_CMDS
	$(IW_MAKE_ENV) $(MAKE) $(IW_MAKE_OPTS) -C $(@D)
endef

define IW_INSTALL_TARGET_CMDS
	$(IW_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
