###############################################################################
#
# Linux kernel target
#
###############################################################################
LINUX_VERSION=$(call qstrip,$(BR2_LINUX_KERNEL_VERSION))

# Compute LINUX_SOURCE and LINUX_SITE from the configuration
ifeq ($(LINUX_VERSION),custom)
LINUX_TARBALL = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
LINUX_SITE = $(dir $(LINUX_TARBALL))
LINUX_SOURCE = $(notdir $(LINUX_TARBALL))
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_GIT),y)
LINUX_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_GIT_REPO_URL))
LINUX_SITE_METHOD = git
else
LINUX_SOURCE = linux-$(LINUX_VERSION).tar.bz2
# In X.Y.Z, get X and Y. We replace dots and dashes by spaces in order
# to use the $(word) function. We support versions such as 3.1,
# 2.6.32, 2.6.32-rc1, 3.0-rc6, etc.
LINUX_VERSION_MAJOR = $(word 1,$(subst ., ,$(subst -, ,$(LINUX_VERSION))))
LINUX_VERSION_MINOR = $(word 2,$(subst ., ,$(subst -, ,$(LINUX_VERSION))))
LINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v$(LINUX_VERSION_MAJOR).$(LINUX_VERSION_MINOR)/
# release candidates are in testing/ subdir
ifneq ($(findstring -rc,$(LINUX_VERSION)),)
LINUX_SITE := $(LINUX_SITE)testing/
endif # -rc
endif

LINUX_PATCHES = $(call qstrip,$(BR2_LINUX_KERNEL_PATCH))

LINUX_INSTALL_IMAGES = YES
LINUX_DEPENDENCIES  += host-module-init-tools

LINUX_MAKE_FLAGS = \
	HOSTCC="$(HOSTCC)" \
	HOSTCFLAGS="$(HOSTCFLAGS)" \
	ARCH=$(KERNEL_ARCH) \
	INSTALL_MOD_PATH=$(TARGET_DIR) \
	CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \
	LZMA="$(LZMA)"

# Get the real Linux version, which tells us where kernel modules are
# going to be installed in the target filesystem.
LINUX_VERSION_PROBED = $(shell $(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) --no-print-directory -s kernelrelease)

ifeq ($(BR2_LINUX_KERNEL_IMAGE_TARGET_CUSTOM),y)
LINUX_IMAGE_NAME=$(call qstrip,$(BR2_LINUX_KERNEL_IMAGE_TARGET_NAME))
else
ifeq ($(BR2_LINUX_KERNEL_UIMAGE),y)
ifeq ($(KERNEL_ARCH),blackfin)
# a uImage, but with a different file name
LINUX_IMAGE_NAME=vmImage
else
LINUX_IMAGE_NAME=uImage
endif
LINUX_DEPENDENCIES+=host-uboot-tools
else ifeq ($(BR2_LINUX_KERNEL_BZIMAGE),y)
LINUX_IMAGE_NAME=bzImage
else ifeq ($(BR2_LINUX_KERNEL_ZIMAGE),y)
LINUX_IMAGE_NAME=zImage
else ifeq ($(BR2_LINUX_KERNEL_VMLINUX_BIN),y)
LINUX_IMAGE_NAME=vmlinux.bin
else ifeq ($(BR2_LINUX_KERNEL_VMLINUX),y)
LINUX_IMAGE_NAME=vmlinux
endif
endif

# Compute the arch path, since i386 and x86_64 are in arch/x86 and not
# in arch/$(KERNEL_ARCH). Even if the kernel creates symbolic links
# for bzImage, arch/i386 and arch/x86_64 do not exist when copying the
# defconfig file.
ifeq ($(KERNEL_ARCH),i386)
KERNEL_ARCH_PATH=$(LINUX_DIR)/arch/x86
else ifeq ($(KERNEL_ARCH),x86_64)
KERNEL_ARCH_PATH=$(LINUX_DIR)/arch/x86
else
KERNEL_ARCH_PATH=$(LINUX_DIR)/arch/$(KERNEL_ARCH)
endif

ifeq ($(BR2_LINUX_KERNEL_VMLINUX),y)
LINUX_IMAGE_PATH=$(LINUX_DIR)/$(LINUX_IMAGE_NAME)
else
ifeq ($(KERNEL_ARCH),avr32)
LINUX_IMAGE_PATH=$(KERNEL_ARCH_PATH)/boot/images/$(LINUX_IMAGE_NAME)
else
LINUX_IMAGE_PATH=$(KERNEL_ARCH_PATH)/boot/$(LINUX_IMAGE_NAME)
endif
endif # BR2_LINUX_KERNEL_VMLINUX

define LINUX_DOWNLOAD_PATCHES
	$(if $(LINUX_PATCHES),
		@$(call MESSAGE,"Download additional patches"))
	$(foreach patch,$(filter ftp://% http://%,$(LINUX_PATCHES)),\
		$(call DOWNLOAD,$(dir $(patch)),$(notdir $(patch)))$(sep))
endef

LINUX_POST_DOWNLOAD_HOOKS += LINUX_DOWNLOAD_PATCHES

define LINUX_APPLY_PATCHES
	for p in $(LINUX_PATCHES) ; do \
		if echo $$p | grep -q -E "^ftp://|^http://" ; then \
			toolchain/patch-kernel.sh $(@D) $(DL_DIR) `basename $$p` ; \
		elif test -d $$p ; then \
			toolchain/patch-kernel.sh $(@D) $$p linux-\*.patch ; \
		else \
			toolchain/patch-kernel.sh $(@D) `dirname $$p` `basename $$p` ; \
		fi \
	done
endef

LINUX_POST_PATCH_HOOKS += LINUX_APPLY_PATCHES


ifeq ($(BR2_LINUX_KERNEL_USE_DEFCONFIG),y)
KERNEL_SOURCE_CONFIG = $(KERNEL_ARCH_PATH)/configs/$(call qstrip,$(BR2_LINUX_KERNEL_DEFCONFIG))_defconfig
else ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG),y)
KERNEL_SOURCE_CONFIG = $(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE)
endif

define LINUX_CONFIGURE_CMDS
	cp $(KERNEL_SOURCE_CONFIG) $(KERNEL_ARCH_PATH)/configs/buildroot_defconfig
	$(TARGET_MAKE_ENV) $(MAKE1) $(LINUX_MAKE_FLAGS) -C $(@D) buildroot_defconfig
	rm $(KERNEL_ARCH_PATH)/configs/buildroot_defconfig
	$(if $(BR2_ARM_EABI),
		$(call KCONFIG_ENABLE_OPT,CONFIG_AEABI,$(@D)/.config),
		$(call KCONFIG_DISABLE_OPT,CONFIG_AEABI,$(@D)/.config))
	# As the kernel gets compiled before root filesystems are
	# built, we create a fake initramfs file list. It'll be
	# replaced later by the real list, and the kernel will be
	# rebuilt using the linux26-rebuild-with-initramfs target.
	$(if $(BR2_TARGET_ROOTFS_INITRAMFS),
		touch $(BINARIES_DIR)/rootfs.initramfs
		$(call KCONFIG_ENABLE_OPT,CONFIG_BLK_DEV_INITRD,$(@D)/.config)
		$(call KCONFIG_SET_OPT,CONFIG_INITRAMFS_SOURCE,\"$(BINARIES_DIR)/rootfs.initramfs\",$(@D)/.config)
		$(call KCONFIG_SET_OPT,CONFIG_INITRAMFS_ROOT_UID,0,$(@D)/.config)
		$(call KCONFIG_SET_OPT,CONFIG_INITRAMFS_ROOT_GID,0,$(@D)/.config)
		$(call KCONFIG_DISABLE_OPT,CONFIG_INITRAMFS_COMPRESSION_NONE,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_INITRAMFS_COMPRESSION_GZIP,$(@D)/.config))
	$(if $(BR2_ROOTFS_DEVICE_CREATION_STATIC),,
		$(call KCONFIG_ENABLE_OPT,CONFIG_DEVTMPFS,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_DEVTMPFS_MOUNT,$(@D)/.config))
	$(if $(BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_MDEV),
		$(call KCONFIG_SET_OPT,CONFIG_UEVENT_HELPER_PATH,\"/sbin/mdev\",$(@D)/.config))
	yes '' | $(TARGET_MAKE_ENV) $(MAKE1) $(LINUX_MAKE_FLAGS) -C $(@D) oldconfig
endef

# Compilation. We make sure the kernel gets rebuilt when the
# configuration has changed.
define LINUX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) $(LINUX_IMAGE_NAME)
	@if grep -q "CONFIG_MODULES=y" $(@D)/.config; then 	\
		$(TARGET_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) modules ;	\
	fi
endef


ifeq ($(BR2_LINUX_KERNEL_INSTALL_TARGET),y)
define LINUX_INSTALL_KERNEL_IMAGE_TO_TARGET
	install -m 0644 -D $(LINUX_IMAGE_PATH) $(TARGET_DIR)/boot/$(LINUX_IMAGE_NAME)
endef
endif

define LINUX_INSTALL_IMAGES_CMDS
	cp $(LINUX_IMAGE_PATH) $(BINARIES_DIR)
endef

define LINUX_INSTALL_TARGET_CMDS
	$(LINUX_INSTALL_KERNEL_IMAGE_TO_TARGET)
	# Install modules and remove symbolic links pointing to build
	# directories, not relevant on the target
	@if grep -q "CONFIG_MODULES=y" $(@D)/.config; then 	\
		$(TARGET_MAKE_ENV) $(MAKE1) $(LINUX_MAKE_FLAGS) -C $(@D) 		\
			DEPMOD="$(HOST_DIR)/usr/sbin/depmod" modules_install ;		\
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/build ;		\
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/source ;	\
	fi
endef

$(eval $(call GENTARGETS,,linux))

linux-menuconfig linux-xconfig linux-gconfig linux-nconfig linux26-menuconfig linux26-xconfig linux26-gconfig linux26-nconfig: dirs $(LINUX_DIR)/.stamp_configured
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) \
		$(subst linux-,,$(subst linux26-,,$@))
	rm -f $(LINUX_DIR)/.stamp_{built,target_installed,images_installed}

linux-savedefconfig linux26-savedefconfig: dirs $(LINUX_DIR)/.stamp_configured
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) \
		$(subst linux-,,$(subst linux26-,,$@))

# Support for rebuilding the kernel after the initramfs file list has
# been generated in $(BINARIES_DIR)/rootfs.initramfs.
$(LINUX_DIR)/.stamp_initramfs_rebuilt: $(LINUX_DIR)/.stamp_target_installed $(LINUX_DIR)/.stamp_images_installed $(BINARIES_DIR)/rootfs.initramfs
	@$(call MESSAGE,"Rebuilding kernel with initramfs")
	# Remove the previously generated initramfs which was empty,
	# to make sure the kernel will actually regenerate it.
	$(RM) -f $(@D)/usr/initramfs_data.cpio*
	# Build the kernel.
	$(TARGET_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) $(LINUX_IMAGE_NAME)
	# Copy the kernel image to its final destination
	cp $(LINUX_IMAGE_PATH) $(BINARIES_DIR)
	$(Q)touch $@

# The initramfs building code must make sure this target gets called
# after it generated the initramfs list of files.
linux-rebuild-with-initramfs linux26-rebuild-with-initramfs: $(LINUX_DIR)/.stamp_initramfs_rebuilt

# Checks to give errors that the user can understand
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(BR2_LINUX_KERNEL_USE_DEFCONFIG),y)
ifeq ($(call qstrip,$(BR2_LINUX_KERNEL_DEFCONFIG)),)
$(error No kernel defconfig name specified, check your BR2_LINUX_KERNEL_DEFCONFIG setting)
endif
endif

ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG),y)
ifeq ($(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE)),)
$(error No kernel configuration file specified, check your BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE setting)
endif
endif

endif
