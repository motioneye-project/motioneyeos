################################################################################
#
# xvisor
#
################################################################################

XVISOR_VERSION = 0.2.8
XVISOR_SITE = http://www.xhypervisor.org/tarball
XVISOR_LICENSE = GPL-2.0+
XVISOR_LICENSE_FILES = COPYING
XVISOR_INSTALL_IMAGES = YES
XVISOR_INSTALL_TARGET = NO

XVISOR_MAKE_TARGETS = all

ifeq ($(BR2_PACKAGE_XVISOR_BUILD_TEST_DTB),y)
XVISOR_MAKE_TARGETS += dtbs
endif

XVISOR_KCONFIG_DOTCONFIG = build/openconf/.config

ifeq ($(BR2_PACKAGE_XVISOR_USE_DEFCONFIG),y)
XVISOR_KCONFIG_DEFCONFIG = $(call qstrip,$(BR2_PACKAGE_XVISOR_DEFCONFIG))-defconfig
else ifeq ($(BR2_PACKAGE_XVISOR_USE_CUSTOM_CONFIG),y)
XVISOR_KCONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_XVISOR_CUSTOM_CONFIG_FILE))
endif
XVISOR_KCONFIG_EDITORS = menuconfig

ifeq ($(BR2_x86_64),y)
XVISOR_ARCH = x86
else ifeq ($(BR2_arm)$(BR2_aarch64),y)
XVISOR_ARCH = arm
endif

ifeq ($(BR2_PACKAGE_XVISOR)$(BR_BUILDING),yy)
ifeq ($(XVISOR_ARCH),)
$(error "Architecture not supported by XVisor")
endif
endif

XVISOR_MAKE_ENV = \
	ARCH=$(XVISOR_ARCH) \
	CROSS_COMPILE=$(TARGET_CROSS)

XVISOR_MAKE_OPTS = $(if $(VERBOSE),VERBOSE=1)

define XVISOR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(XVISOR_MAKE_ENV) $(MAKE) $(XVISOR_MAKE_OPTS) \
		-C $(@D) $(XVISOR_MAKE_TARGETS)
endef

define XVISOR_INSTALL_IMAGES_CMDS
	$(INSTALL) -m 0644 -D $(@D)/build/vmm.bin $(BINARIES_DIR)/vmm.bin
endef

ifeq ($(BR2_PACKAGE_XVISOR_CREATE_UBOOT_IMAGE),y)
XVISOR_DEPENDENCIES += host-uboot-tools
define XVISOR_CREATE_UBOOT_IMAGE
	$(MKIMAGE) -A $(MKIMAGE_ARCH) -O linux -T kernel -C none \
		-a 0x00008000 -e 0x00008000 \
		-n Xvisor -d $(BINARIES_DIR)/vmm.bin $(BINARIES_DIR)/uvmm.bin
endef
endif

XVISOR_POST_INSTALL_IMAGES_HOOKS += XVISOR_CREATE_UBOOT_IMAGE

# Checks to give errors that the user can understand
ifeq ($(BR_BUILDING),y)

ifeq ($(BR2_PACKAGE_XVISOR_USE_DEFCONFIG),y)
ifeq ($(call qstrip,$(BR2_PACKAGE_XVISOR_DEFCONFIG)),)
$(error No Xvisor defconfig name specified, check your BR2_PACKAGE_XVISOR_DEFCONFIG setting)
endif
endif

ifeq ($(BR2_PACKAGE_XVISOR_USE_CUSTOM_CONFIG),y)
ifeq ($(BR2_PACKAGE_XVISOR_CUSTOM_CONFIG_FILE),)
$(error No Xvisor configuration file specified, check your BR2_PACKAGE_XVISOR_CUSTOM_CONFIG_FILE setting)
endif
endif

endif

$(eval $(kconfig-package))
