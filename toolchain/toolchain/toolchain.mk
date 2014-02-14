################################################################################
#
# toolchain
#
################################################################################

TOOLCHAIN_SOURCE =

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
TOOLCHAIN_DEPENDENCIES += toolchain-buildroot
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
TOOLCHAIN_DEPENDENCIES += toolchain-external
endif

TOOLCHAIN_ADD_TOOLCHAIN_DEPENDENCY = NO

$(eval $(generic-package))

toolchain: $(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake
