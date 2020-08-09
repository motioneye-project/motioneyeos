################################################################################
#
# mender-grubenv
#
################################################################################

MENDER_GRUBENV_VERSION = 1.3.0
MENDER_GRUBENV_SITE = $(call github,mendersoftware,grub-mender-grubenv,$(MENDER_GRUBENV_VERSION))
MENDER_GRUBENV_LICENSE = Apache-2.0
MENDER_GRUBENV_LICENSE_FILES = LICENSE
# Grub2 must be built first so this package can overwrite the config files
# provided by grub.
MENDER_GRUBENV_DEPENDENCIES = grub2
MENDER_GRUBENV_INSTALL_IMAGES = YES

ifeq ($(BR2_TARGET_GRUB2_I386_PC)$(BR2_TARGET_GRUB2_ARM_UBOOT),y)
MENDER_GRUBENV_ENV_DIR = /boot/grub
else
MENDER_GRUBENV_ENV_DIR = /boot/EFI/BOOT
endif

MENDER_GRUBENV_MAKE_ENV = \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_MAKE_ENV) \
	ENV_DIR=$(MENDER_GRUBENV_ENV_DIR)

MENDER_GRUBENV_DEFINES = \
	$(or $(call qstrip,$(BR2_PACKAGE_MENDER_GRUBENV_DEFINES)),\
		$(@D)/mender_grubenv_defines.example)

# These grub modules must be built in for the grub scripts to work properly.
# Without them, the system will not boot.
MENDER_GRUBENV_MANDATORY_MODULES=loadenv hashsum echo halt gcry_sha256 test
MENDER_GRUBENV_MODULES_MISSING = \
	$(filter-out $(call qstrip,$(BR2_TARGET_GRUB2_BUILTIN_MODULES)),\
		$(MENDER_GRUBENV_MANDATORY_MODULES))

ifeq ($(BR2_PACKAGE_MENDER_GRUBENV)$(BR_BUILDING),yy)
ifneq ($(MENDER_GRUBENV_MODULES_MISSING),)
$(error The following missing grub2 modules must be enabled for mender-grubenv \
	to work: $(MENDER_GRUBENV_MODULES_MISSING))
endif
endif

define MENDER_GRUBENV_CONFIGURE_CMDS
	$(INSTALL) -m 0644 $(MENDER_GRUBENV_DEFINES) $(@D)/mender_grubenv_defines
endef

define MENDER_GRUBENV_BUILD_CMDS
	$(MENDER_GRUBENV_MAKE_ENV) $(MAKE) -C $(@D)
endef

define MENDER_GRUBENV_INSTALL_TARGET_CMDS
	$(MENDER_GRUBENV_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

# Overwrite the default grub2 config files with the ones in this package.
define MENDER_GRUBENV_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/efi-part/EFI/BOOT
	cp -dpfr $(TARGET_DIR)/boot/EFI/BOOT/grub.cfg \
		$(TARGET_DIR)/boot/EFI/BOOT/mender_grubenv* \
		$(BINARIES_DIR)/efi-part/EFI/BOOT
endef

$(eval $(generic-package))
