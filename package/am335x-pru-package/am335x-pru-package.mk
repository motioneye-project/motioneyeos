################################################################################
#
# am335x-pru-package
#
################################################################################

AM335X_PRU_PACKAGE_VERSION = 506e074859891a2b350eb4f5fcb451c4961410ea
AM335X_PRU_PACKAGE_SITE = $(call github,beagleboard,am335x_pru_package,$(AM335X_PRU_PACKAGE_VERSION))
AM335X_PRU_PACKAGE_LICENSE = BSD-3c
AM335X_PRU_PACKAGE_LICENSE_FILES = pru_sw/utils/LICENCE.txt
AM335X_PRU_PACKAGE_DEPENDENCIES = host-am335x-pru-package
AM335X_PRU_PACKAGE_INSTALL_STAGING = YES

# The default 'all' rule builds everything, when we just need the library
ifeq ($(BR2_ENABLE_DEBUG),y)
AM335X_MAKE_TARGET = debug $(if $(BR2_PREFER_STATIC_LIB),,sodebug)
else
AM335X_MAKE_TARGET = release $(if $(BR2_PREFER_STATIC_LIB),,sorelease)
endif

define AM335X_PRU_PACKAGE_BUILD_CMDS
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" \
		-C $(@D)/pru_sw/app_loader/interface $(AM335X_MAKE_TARGET)
endef

# 'install' installs whatever was built, and our patch removes the dependency
# on the release build, so we can use it to install whatever we built above.
define AM335X_PRU_PACKAGE_INSTALL_STAGING_CMDS
	$(MAKE1) DESTDIR="$(STAGING_DIR)" PREFIX="/usr" \
		-C $(@D)/pru_sw/app_loader/interface install
endef

define AM335X_PRU_PACKAGE_INSTALL_TARGET_CMDS
	$(MAKE1) DESTDIR="$(TARGET_DIR)" PREFIX="/usr" \
		-C $(@D)/pru_sw/app_loader/interface install
endef

# The debug libraries are named differently than the release ones,
# so we must provide a symlink to still be able to link with them.
ifeq ($(BR2_ENABLE_DEBUG),y)

define AM335X_PRU_PACKAGE_LN_DEBUG_STAGING_STATIC
	ln -sf libprussdrvd.a $(STAGING_DIR)/usr/lib/libprussdrv.a
endef
AM335X_PRU_PACKAGE_POST_INSTALL_STAGING_HOOKS += AM335X_PRU_PACKAGE_LN_DEBUG_STAGING_STATIC

ifeq ($(BR2_PREFER_STATIC_LIB),)

define AM335X_PRU_PACKAGE_LN_DEBUG_STAGING_SHARED
	ln -sf libprussdrvd.so $(STAGING_DIR)/usr/lib/libprussdrv.so
endef
AM335X_PRU_PACKAGE_POST_INSTALL_STAGING_HOOKS += AM335X_PRU_PACKAGE_LN_DEBUG_STAGING_SHARED

define AM335X_PRU_PACKAGE_LN_DEBUG_TARGET
	ln -sf libprussdrvd.so $(TARGET_DIR)/usr/lib/libprussdrv.so
endef
AM335X_PRU_PACKAGE_POST_INSTALL_TARGET_HOOKS += AM335X_PRU_PACKAGE_LN_DEBUG_TARGET

endif # !STATIC

endif # DEBUG

define HOST_AM335X_PRU_PACKAGE_BUILD_CMDS
	cd $(@D)/pru_sw/utils/pasm_source; \
	$(HOSTCC) -Wall -D_UNIX_ pasm.c pasmpp.c pasmexp.c pasmop.c \
		pasmdot.c pasmstruct.c pasmmacro.c path_utils.c -o ../pasm
endef

define HOST_AM335X_PRU_PACKAGE_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/pru_sw/utils/pasm $(HOST_DIR)/usr/bin/pasm
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
