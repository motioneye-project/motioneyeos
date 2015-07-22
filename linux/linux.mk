################################################################################
#
# Linux kernel target
#
################################################################################

LINUX_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_VERSION))
LINUX_LICENSE = GPLv2
LINUX_LICENSE_FILES = COPYING

# Compute LINUX_SOURCE and LINUX_SITE from the configuration
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_TARBALL),y)
LINUX_TARBALL = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
LINUX_SITE = $(patsubst %/,%,$(dir $(LINUX_TARBALL)))
LINUX_SOURCE = $(notdir $(LINUX_TARBALL))
BR_NO_CHECK_HASH_FOR += $(LINUX_SOURCE)
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_LOCAL),y)
LINUX_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_LOCAL_PATH))
LINUX_SITE_METHOD = local
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_GIT),y)
LINUX_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
LINUX_SITE_METHOD = git
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_HG),y)
LINUX_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
LINUX_SITE_METHOD = hg
else
LINUX_SOURCE = linux-$(LINUX_VERSION).tar.xz
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_VERSION),y)
BR_NO_CHECK_HASH_FOR += $(LINUX_SOURCE)
endif
ifeq ($(BR2_LINUX_KERNEL_SAME_AS_HEADERS)$(BR2_KERNEL_HEADERS_VERSION),yy)
BR_NO_CHECK_HASH_FOR += $(LINUX_SOURCE)
endif
# In X.Y.Z, get X and Y. We replace dots and dashes by spaces in order
# to use the $(word) function. We support versions such as 4.0, 3.1,
# 2.6.32, 2.6.32-rc1, 3.0-rc6, etc.
ifeq ($(findstring x2.6.,x$(LINUX_VERSION)),x2.6.)
LINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v2.6
else ifeq ($(findstring x3.,x$(LINUX_VERSION)),x3.)
LINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v3.x
else ifeq ($(findstring x4.,x$(LINUX_VERSION)),x4.)
LINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v4.x
endif
# release candidates are in testing/ subdir
ifneq ($(findstring -rc,$(LINUX_VERSION)),)
LINUX_SITE := $(LINUX_SITE)/testing
endif # -rc
endif

LINUX_PATCHES = $(call qstrip,$(BR2_LINUX_KERNEL_PATCH))

# We rely on the generic package infrastructure to download and apply
# remote patches (downloaded from ftp, http or https). For local
# patches, we can't rely on that infrastructure, because there might
# be directories in the patch list (unlike for other packages).
LINUX_PATCH = $(filter ftp://% http://% https://%,$(LINUX_PATCHES))

LINUX_INSTALL_IMAGES = YES
LINUX_DEPENDENCIES += host-kmod host-lzop

ifeq ($(BR2_LINUX_KERNEL_UBOOT_IMAGE),y)
LINUX_DEPENDENCIES += host-uboot-tools
endif

LINUX_MAKE_FLAGS = \
	HOSTCC="$(HOSTCC)" \
	HOSTCFLAGS="$(HOSTCFLAGS)" \
	ARCH=$(KERNEL_ARCH) \
	INSTALL_MOD_PATH=$(TARGET_DIR) \
	CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \
	DEPMOD=$(HOST_DIR)/sbin/depmod

LINUX_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	BR_BINARIES_DIR=$(BINARIES_DIR)

# Get the real Linux version, which tells us where kernel modules are
# going to be installed in the target filesystem.
LINUX_VERSION_PROBED = `$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) --no-print-directory -s kernelrelease 2>/dev/null`

ifeq ($(BR2_LINUX_KERNEL_USE_INTREE_DTS),y)
KERNEL_DTS_NAME = $(call qstrip,$(BR2_LINUX_KERNEL_INTREE_DTS_NAME))
else ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_DTS),y)
# We keep only the .dts files, so that the user can specify both .dts
# and .dtsi files in BR2_LINUX_KERNEL_CUSTOM_DTS_PATH. Both will be
# copied to arch/<arch>/boot/dts, but only the .dts files will
# actually be generated as .dtb.
KERNEL_DTS_NAME = $(basename $(filter %.dts,$(notdir $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_DTS_PATH)))))
endif

KERNEL_DTBS = $(addsuffix .dtb,$(KERNEL_DTS_NAME))

ifeq ($(BR2_LINUX_KERNEL_IMAGE_TARGET_CUSTOM),y)
LINUX_IMAGE_NAME = $(call qstrip,$(BR2_LINUX_KERNEL_IMAGE_NAME))
LINUX_TARGET_NAME = $(call qstrip,$(BR2_LINUX_KERNEL_IMAGE_TARGET_NAME))
ifeq ($(LINUX_IMAGE_NAME),)
LINUX_IMAGE_NAME = $(LINUX_TARGET_NAME)
endif
else
ifeq ($(BR2_LINUX_KERNEL_UIMAGE),y)
LINUX_IMAGE_NAME = uImage
else ifeq ($(BR2_LINUX_KERNEL_APPENDED_UIMAGE),y)
LINUX_IMAGE_NAME = uImage
else ifeq ($(BR2_LINUX_KERNEL_BZIMAGE),y)
LINUX_IMAGE_NAME = bzImage
else ifeq ($(BR2_LINUX_KERNEL_ZIMAGE),y)
LINUX_IMAGE_NAME = zImage
else ifeq ($(BR2_LINUX_KERNEL_APPENDED_ZIMAGE),y)
LINUX_IMAGE_NAME = zImage
else ifeq ($(BR2_LINUX_KERNEL_CUIMAGE),y)
LINUX_IMAGE_NAME = cuImage.$(KERNEL_DTS_NAME)
else ifeq ($(BR2_LINUX_KERNEL_SIMPLEIMAGE),y)
LINUX_IMAGE_NAME = simpleImage.$(KERNEL_DTS_NAME)
else ifeq ($(BR2_LINUX_KERNEL_LINUX_BIN),y)
LINUX_IMAGE_NAME = linux.bin
else ifeq ($(BR2_LINUX_KERNEL_VMLINUX_BIN),y)
LINUX_IMAGE_NAME = vmlinux.bin
else ifeq ($(BR2_LINUX_KERNEL_VMLINUX),y)
LINUX_IMAGE_NAME = vmlinux
else ifeq ($(BR2_LINUX_KERNEL_VMLINUZ),y)
LINUX_IMAGE_NAME = vmlinuz
endif
# The if-else blocks above are all the image types we know of, and all
# come from a Kconfig choice, so we know we have LINUX_IMAGE_NAME set
# to something
LINUX_TARGET_NAME = $(LINUX_IMAGE_NAME)
endif

LINUX_KERNEL_UIMAGE_LOADADDR = $(call qstrip,$(BR2_LINUX_KERNEL_UIMAGE_LOADADDR))
ifneq ($(LINUX_KERNEL_UIMAGE_LOADADDR),)
LINUX_MAKE_FLAGS += LOADADDR="$(LINUX_KERNEL_UIMAGE_LOADADDR)"
endif

# Compute the arch path, since i386 and x86_64 are in arch/x86 and not
# in arch/$(KERNEL_ARCH). Even if the kernel creates symbolic links
# for bzImage, arch/i386 and arch/x86_64 do not exist when copying the
# defconfig file.
ifeq ($(KERNEL_ARCH),i386)
KERNEL_ARCH_PATH = $(LINUX_DIR)/arch/x86
else ifeq ($(KERNEL_ARCH),x86_64)
KERNEL_ARCH_PATH = $(LINUX_DIR)/arch/x86
else
KERNEL_ARCH_PATH = $(LINUX_DIR)/arch/$(KERNEL_ARCH)
endif

ifeq ($(BR2_LINUX_KERNEL_VMLINUX),y)
LINUX_IMAGE_PATH = $(LINUX_DIR)/$(LINUX_IMAGE_NAME)
else ifeq ($(BR2_LINUX_KERNEL_VMLINUZ),y)
LINUX_IMAGE_PATH = $(LINUX_DIR)/$(LINUX_IMAGE_NAME)
else
LINUX_IMAGE_PATH = $(KERNEL_ARCH_PATH)/boot/$(LINUX_IMAGE_NAME)
endif # BR2_LINUX_KERNEL_VMLINUX

define LINUX_APPLY_LOCAL_PATCHES
	for p in $(filter-out ftp://% http://% https://%,$(LINUX_PATCHES)) ; do \
		if test -d $$p ; then \
			$(APPLY_PATCHES) $(@D) $$p \*.patch || exit 1 ; \
		else \
			$(APPLY_PATCHES) $(@D) `dirname $$p` `basename $$p` || exit 1; \
		fi \
	done
endef

LINUX_POST_PATCH_HOOKS += LINUX_APPLY_LOCAL_PATCHES

ifeq ($(BR2_LINUX_KERNEL_USE_DEFCONFIG),y)
KERNEL_SOURCE_CONFIG = $(KERNEL_ARCH_PATH)/configs/$(call qstrip,$(BR2_LINUX_KERNEL_DEFCONFIG))_defconfig
else ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG),y)
KERNEL_SOURCE_CONFIG = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE))
endif

LINUX_KCONFIG_FILE = $(KERNEL_SOURCE_CONFIG)
LINUX_KCONFIG_FRAGMENT_FILES = $(call qstrip,$(BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES))
LINUX_KCONFIG_EDITORS = menuconfig xconfig gconfig nconfig
LINUX_KCONFIG_OPTS = $(LINUX_MAKE_FLAGS)

define LINUX_KCONFIG_FIXUP_CMDS
	$(if $(BR2_arm)$(BR2_armeb),
		$(call KCONFIG_ENABLE_OPT,CONFIG_AEABI,$(@D)/.config))
	$(if $(BR2_TARGET_ROOTFS_CPIO),
		$(call KCONFIG_ENABLE_OPT,CONFIG_BLK_DEV_INITRD,$(@D)/.config))
	# As the kernel gets compiled before root filesystems are
	# built, we create a fake cpio file. It'll be
	# replaced later by the real cpio archive, and the kernel will be
	# rebuilt using the linux-rebuild-with-initramfs target.
	$(if $(BR2_TARGET_ROOTFS_INITRAMFS),
		touch $(BINARIES_DIR)/rootfs.cpio
		$(call KCONFIG_SET_OPT,CONFIG_INITRAMFS_SOURCE,"$${BR_BINARIES_DIR}/rootfs.cpio",$(@D)/.config)
		$(call KCONFIG_SET_OPT,CONFIG_INITRAMFS_ROOT_UID,0,$(@D)/.config)
		$(call KCONFIG_SET_OPT,CONFIG_INITRAMFS_ROOT_GID,0,$(@D)/.config))
	$(if $(BR2_ROOTFS_DEVICE_CREATION_STATIC),,
		$(call KCONFIG_ENABLE_OPT,CONFIG_DEVTMPFS,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_DEVTMPFS_MOUNT,$(@D)/.config))
	$(if $(BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_EUDEV),
		$(call KCONFIG_ENABLE_OPT,CONFIG_INOTIFY_USER,$(@D)/.config))
	$(if $(BR2_PACKAGE_KTAP),
		$(call KCONFIG_ENABLE_OPT,CONFIG_DEBUG_FS,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_ENABLE_DEFAULT_TRACERS,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_PERF_EVENTS,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_FUNCTION_TRACER,$(@D)/.config))
	$(if $(BR2_PACKAGE_SYSTEMD),
		$(call KCONFIG_ENABLE_OPT,CONFIG_CGROUPS,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_INOTIFY_USER,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_FHANDLE,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_AUTOFS4_FS,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_TMPFS_POSIX_ACL,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_TMPFS_POSIX_XATTR,$(@D)/.config))
	$(if $(BR2_PACKAGE_SMACK),
		$(call KCONFIG_ENABLE_OPT,CONFIG_SECURITY,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_SECURITY_SMACK,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_SECURITY_NETWORK,$(@D)/.config))
	$(if $(BR2_PACKAGE_IPTABLES),
		$(call KCONFIG_ENABLE_OPT,CONFIG_IP_NF_IPTABLES,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_IP_NF_FILTER,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_NETFILTER,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_NETFILTER_XTABLES,$(@D)/.config))
	$(if $(BR2_PACKAGE_XTABLES_ADDONS),
		$(call KCONFIG_ENABLE_OPT,CONFIG_NF_CONNTRACK,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_NF_CONNTRACK_MARK,$(@D)/.config))
	$(if $(BR2_LINUX_KERNEL_APPENDED_DTB),
		$(call KCONFIG_ENABLE_OPT,CONFIG_ARM_APPENDED_DTB,$(@D)/.config))
endef

ifeq ($(BR2_LINUX_KERNEL_DTS_SUPPORT),y)
ifeq ($(BR2_LINUX_KERNEL_DTB_IS_SELF_BUILT),)
define LINUX_BUILD_DTB
	$(LINUX_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) $(KERNEL_DTBS)
endef
define LINUX_INSTALL_DTB
	# dtbs moved from arch/<ARCH>/boot to arch/<ARCH>/boot/dts since 3.8-rc1
	cp $(addprefix \
		$(KERNEL_ARCH_PATH)/boot/$(if $(wildcard \
		$(addprefix $(KERNEL_ARCH_PATH)/boot/dts/,$(KERNEL_DTBS))),dts/),$(KERNEL_DTBS)) \
		$(BINARIES_DIR)/
endef
define LINUX_INSTALL_DTB_TARGET
	# dtbs moved from arch/<ARCH>/boot to arch/<ARCH>/boot/dts since 3.8-rc1
	cp $(addprefix \
		$(KERNEL_ARCH_PATH)/boot/$(if $(wildcard \
		$(addprefix $(KERNEL_ARCH_PATH)/boot/dts/,$(KERNEL_DTBS))),dts/),$(KERNEL_DTBS)) \
		$(TARGET_DIR)/boot/
endef
endif
endif

ifeq ($(BR2_LINUX_KERNEL_APPENDED_DTB),y)
# dtbs moved from arch/$ARCH/boot to arch/$ARCH/boot/dts since 3.8-rc1
define LINUX_APPEND_DTB
	if [ -e $(KERNEL_ARCH_PATH)/boot/$(KERNEL_DTS_NAME).dtb ]; then \
		cat $(KERNEL_ARCH_PATH)/boot/$(KERNEL_DTS_NAME).dtb; \
	else \
		cat $(KERNEL_ARCH_PATH)/boot/dts/$(KERNEL_DTS_NAME).dtb; \
	fi >> $(KERNEL_ARCH_PATH)/boot/zImage
endef
ifeq ($(BR2_LINUX_KERNEL_APPENDED_UIMAGE),y)
# We need to generate a new u-boot image that takes into
# account the extra-size added by the device tree at the end
# of the image. To do so, we first need to retrieve both load
# address and entry point for the kernel from the already
# generate uboot image before using mkimage -l.
LINUX_APPEND_DTB += $(sep) MKIMAGE_ARGS=`$(MKIMAGE) -l $(LINUX_IMAGE_PATH) |\
	sed -n -e 's/Image Name:[ ]*\(.*\)/-n \1/p' -e 's/Load Address:/-a/p' -e 's/Entry Point:/-e/p'`; \
	$(MKIMAGE) -A $(MKIMAGE_ARCH) -O linux \
	-T kernel -C none $${MKIMAGE_ARGS} \
	-d $(KERNEL_ARCH_PATH)/boot/zImage $(LINUX_IMAGE_PATH);
endif
endif

# Compilation. We make sure the kernel gets rebuilt when the
# configuration has changed.
define LINUX_BUILD_CMDS
	$(if $(BR2_LINUX_KERNEL_USE_CUSTOM_DTS),
		cp $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_DTS_PATH)) $(KERNEL_ARCH_PATH)/boot/dts/)
	$(LINUX_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) $(LINUX_TARGET_NAME)
	@if grep -q "CONFIG_MODULES=y" $(@D)/.config; then 	\
		$(LINUX_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) modules ;	\
	fi
	$(LINUX_BUILD_DTB)
	$(LINUX_APPEND_DTB)
endef


ifeq ($(BR2_LINUX_KERNEL_INSTALL_TARGET),y)
define LINUX_INSTALL_KERNEL_IMAGE_TO_TARGET
	install -m 0644 -D $(LINUX_IMAGE_PATH) $(TARGET_DIR)/boot/$(LINUX_IMAGE_NAME)
	$(LINUX_INSTALL_DTB_TARGET)
endef
endif


define LINUX_INSTALL_HOST_TOOLS
	# Installing dtc (device tree compiler) as host tool, if selected
	if grep -q "CONFIG_DTC=y" $(@D)/.config; then 	\
		$(INSTALL) -D -m 0755 $(@D)/scripts/dtc/dtc $(HOST_DIR)/usr/bin/dtc ;	\
	fi
endef


define LINUX_INSTALL_IMAGES_CMDS
	cp $(LINUX_IMAGE_PATH) $(BINARIES_DIR)
	$(LINUX_INSTALL_DTB)
endef

define LINUX_INSTALL_TARGET_CMDS
	$(LINUX_INSTALL_KERNEL_IMAGE_TO_TARGET)
	# Install modules and remove symbolic links pointing to build
	# directories, not relevant on the target
	@if grep -q "CONFIG_MODULES=y" $(@D)/.config; then 	\
		$(LINUX_MAKE_ENV) $(MAKE1) $(LINUX_MAKE_FLAGS) -C $(@D) modules_install; \
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/build ;		\
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/source ;	\
	fi
	$(LINUX_INSTALL_HOST_TOOLS)
endef

# Include all our extensions and tools definitions.
#
# Note: our package infrastructure uses the full-path of the last-scanned
# Makefile to determine what package we're currently defining, using the
# last directory component in the path. As such, including other Makefile,
# like below, before we call one of the *-package macro is usally not
# working.
# However, since the files we include here are in the same directory as
# the current Makefile, we are OK. But this is a hard requirement: files
# included here *must* be in the same directory!
include $(sort $(wildcard linux/linux-ext-*.mk))
include $(sort $(wildcard linux/linux-tool-*.mk))

LINUX_PATCH_DEPENDENCIES += $(foreach ext,$(LINUX_EXTENSIONS),\
	$(if $(BR2_LINUX_KERNEL_EXT_$(call UPPERCASE,$(ext))),$(ext)))

LINUX_PRE_PATCH_HOOKS += $(foreach ext,$(LINUX_EXTENSIONS),\
	$(if $(BR2_LINUX_KERNEL_EXT_$(call UPPERCASE,$(ext))),\
		$(call UPPERCASE,$(ext))_PREPARE_KERNEL))

# Install Linux kernel tools in the staging directory since some tools
# may install shared libraries and headers (e.g. cpupower). The kernel
# image is NOT installed in the staging directory.
LINUX_INSTALL_STAGING = YES

LINUX_DEPENDENCIES += $(foreach tool,$(LINUX_TOOLS),\
	$(if $(BR2_LINUX_KERNEL_TOOL_$(call UPPERCASE,$(tool))),\
		$($(call UPPERCASE,$(tool))_DEPENDENCIES)))

LINUX_POST_BUILD_HOOKS += $(foreach tool,$(LINUX_TOOLS),\
	$(if $(BR2_LINUX_KERNEL_TOOL_$(call UPPERCASE,$(tool))),\
		$(call UPPERCASE,$(tool))_BUILD_CMDS))

LINUX_POST_INSTALL_STAGING_HOOKS += $(foreach tool,$(LINUX_TOOLS),\
	$(if $(BR2_LINUX_KERNEL_TOOL_$(call UPPERCASE,$(tool))),\
		$(call UPPERCASE,$(tool))_INSTALL_STAGING_CMDS))

LINUX_POST_INSTALL_TARGET_HOOKS += $(foreach tool,$(LINUX_TOOLS),\
	$(if $(BR2_LINUX_KERNEL_TOOL_$(call UPPERCASE,$(tool))),\
		$(call UPPERCASE,$(tool))_INSTALL_TARGET_CMDS))

# Checks to give errors that the user can understand
ifeq ($(BR_BUILDING),y)

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

ifeq ($(BR2_LINUX_KERNEL_DTS_SUPPORT)$(KERNEL_DTS_NAME),y)
$(error No kernel device tree source specified, check your \
BR2_LINUX_KERNEL_USE_INTREE_DTS / BR2_LINUX_KERNEL_USE_CUSTOM_DTS settings)
endif

ifeq ($(BR2_LINUX_KERNEL_APPENDED_DTB),y)
ifneq ($(words $(KERNEL_DTS_NAME)),1)
$(error Kernel with appended device tree needs exactly one DTS source. \
	Check BR2_LINUX_KERNEL_INTREE_DTS_NAME or BR2_LINUX_KERNEL_CUSTOM_DTS_PATH.)
endif
endif

endif # BR_BUILDING

$(eval $(kconfig-package))

# Support for rebuilding the kernel after the cpio archive has
# been generated in $(BINARIES_DIR)/rootfs.cpio.
$(LINUX_DIR)/.stamp_initramfs_rebuilt: $(LINUX_DIR)/.stamp_target_installed $(LINUX_DIR)/.stamp_images_installed $(BINARIES_DIR)/rootfs.cpio
	@$(call MESSAGE,"Rebuilding kernel with initramfs")
	# Build the kernel.
	$(LINUX_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) $(LINUX_TARGET_NAME)
	$(LINUX_APPEND_DTB)
	# Copy the kernel image to its final destination
	cp $(LINUX_IMAGE_PATH) $(BINARIES_DIR)
	# If there is a .ub file copy it to the final destination
	test ! -f $(LINUX_IMAGE_PATH).ub || cp $(LINUX_IMAGE_PATH).ub $(BINARIES_DIR)
	$(Q)touch $@

# The initramfs building code must make sure this target gets called
# after it generated the initramfs list of files.
linux-rebuild-with-initramfs: $(LINUX_DIR)/.stamp_initramfs_rebuilt
