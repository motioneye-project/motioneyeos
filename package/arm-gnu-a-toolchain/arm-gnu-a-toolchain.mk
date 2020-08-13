################################################################################
#
# arm-gnu-a-toolchain
#
################################################################################

ARM_GNU_A_TOOLCHAIN_VERSION = 9.2-2019.12
ARM_GNU_A_TOOLCHAIN_SITE = https://developer.arm.com/-/media/Files/downloads/gnu-a/$(ARM_GNU_A_TOOLCHAIN_VERSION)/binrel
ARM_GNU_A_TOOLCHAIN_SOURCE = gcc-arm-$(ARM_GNU_A_TOOLCHAIN_VERSION)-x86_64-arm-none-eabi.tar.xz
ARM_GNU_A_TOOLCHAIN_LICENSE = GPL-3.0+

HOST_ARM_GNU_A_TOOLCHAIN_INSTALL_DIR = $(HOST_DIR)/opt/gcc-arm-none-eabi

define HOST_ARM_GNU_A_TOOLCHAIN_INSTALL_CMDS
	rm -rf $(HOST_ARM_GNU_A_TOOLCHAIN_INSTALL_DIR)
	mkdir -p $(HOST_ARM_GNU_A_TOOLCHAIN_INSTALL_DIR)
	cp -rf $(@D)/* $(HOST_ARM_GNU_A_TOOLCHAIN_INSTALL_DIR)/

	mkdir -p $(HOST_DIR)/bin
	cd $(HOST_DIR)/bin && \
	for i in ../opt/gcc-arm-none-eabi/bin/*; do \
		ln -sf $$i; \
	done
endef

$(eval $(host-generic-package))
