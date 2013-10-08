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

$(eval $(generic-package))

toolchain-source: prepare dirs dependencies $(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake

