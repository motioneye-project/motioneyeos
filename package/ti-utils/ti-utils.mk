################################################################################
#
# ti-utils
#
################################################################################

TI_UTILS_VERSION = 06dbdb2727354b5f3ad7c723897f40051fddee49
TI_UTILS_SITE = $(call github,gxk,ti-utils,$(TI_UTILS_VERSION))
TI_UTILS_DEPENDENCIES = libnl host-pkgconf
TI_UTILS_LICENSE = BSD-3c
TI_UTILS_LICENSE_FILES = COPYING

TI_UTILS_CFLAGS = `$(PKG_CONFIG_HOST_BINARY) --cflags libnl-genl-3.0`
TI_UTILS_LIBS = `$(PKG_CONFIG_HOST_BINARY) --libs libnl-genl-3.0`

define TI_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) NFSROOT="$(STAGING_DIR)" \
		CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(TI_UTILS_CFLAGS)" \
		LIBS="$(TI_UTILS_LIBS)" -C $(@D) all
endef

define TI_UTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/calibrator \
		$(TARGET_DIR)/usr/bin/calibrator
	$(INSTALL) -m 0755 -D $(@D)/scripts/go.sh \
		$(TARGET_DIR)/usr/share/ti-utils/scripts/go.sh

	cp -r $(@D)/ini_files $(TARGET_DIR)/usr/share/ti-utils
endef

$(eval $(generic-package))
