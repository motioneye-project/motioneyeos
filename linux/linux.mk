################################################################################
#
# Linux kernel target
#
################################################################################

LINUX_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_VERSION))
LINUX_LICENSE = GPL-2.0
LINUX_LICENSE_FILES = COPYING

define LINUX_HELP_CMDS
	@echo '  linux-menuconfig       - Run Linux kernel menuconfig'
	@echo '  linux-savedefconfig    - Run Linux kernel savedefconfig'
	@echo '  linux-update-defconfig - Save the Linux configuration to the path specified'
	@echo '                             by BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE'
endef

# Compute LINUX_SOURCE and LINUX_SITE from the configuration
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_TARBALL),y)
LINUX_TARBALL = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
LINUX_SITE = $(patsubst %/,%,$(dir $(LINUX_TARBALL)))
LINUX_SOURCE = $(notdir $(LINUX_TARBALL))
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_GIT),y)
LINUX_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
LINUX_SITE_METHOD = git
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_HG),y)
LINUX_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
LINUX_SITE_METHOD = hg
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_SVN),y)
LINUX_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
LINUX_SITE_METHOD = svn
else ifeq ($(BR2_LINUX_KERNEL_LATEST_CIP_VERSION),y)
LINUX_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-cip.git
else ifneq ($(findstring -rc,$(LINUX_VERSION)),)
# Since 4.12-rc1, -rc kernels are generated from cgit. This also works for
# older -rc kernels.
LINUX_SITE = https://git.kernel.org/torvalds/t
else
LINUX_SOURCE = linux-$(LINUX_VERSION).tar.xz
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
endif

ifeq ($(BR2_LINUX_KERNEL)$(BR2_LINUX_KERNEL_LATEST_VERSION),y)
BR_NO_CHECK_HASH_FOR += $(LINUX_SOURCE)
endif

LINUX_PATCHES = $(call qstrip,$(BR2_LINUX_KERNEL_PATCH))

# We rely on the generic package infrastructure to download and apply
# remote patches (downloaded from ftp, http or https). For local
# patches, we can't rely on that infrastructure, because there might
# be directories in the patch list (unlike for other packages).
LINUX_PATCH = $(filter ftp://% http://% https://%,$(LINUX_PATCHES))

LINUX_INSTALL_IMAGES = YES
LINUX_DEPENDENCIES += host-kmod

# host tools needed for kernel compression
ifeq ($(BR2_LINUX_KERNEL_LZ4),y)
LINUX_DEPENDENCIES += host-lz4
else ifeq ($(BR2_LINUX_KERNEL_LZMA),y)
LINUX_DEPENDENCIES += host-lzma
else ifeq ($(BR2_LINUX_KERNEL_LZO),y)
LINUX_DEPENDENCIES += host-lzop
else ifeq ($(BR2_LINUX_KERNEL_XZ),y)
LINUX_DEPENDENCIES += host-xz
endif
LINUX_COMPRESSION_OPT_$(BR2_LINUX_KERNEL_GZIP) += CONFIG_KERNEL_GZIP
LINUX_COMPRESSION_OPT_$(BR2_LINUX_KERNEL_LZ4) += CONFIG_KERNEL_LZ4
LINUX_COMPRESSION_OPT_$(BR2_LINUX_KERNEL_LZMA) += CONFIG_KERNEL_LZMA
LINUX_COMPRESSION_OPT_$(BR2_LINUX_KERNEL_LZO) += CONFIG_KERNEL_LZO
LINUX_COMPRESSION_OPT_$(BR2_LINUX_KERNEL_XZ) += CONFIG_KERNEL_XZ

# If host-uboot-tools is selected by the user, assume it is needed to
# create a custom image
ifeq ($(BR2_PACKAGE_HOST_UBOOT_TOOLS),y)
LINUX_DEPENDENCIES += host-uboot-tools
endif

ifneq ($(ARCH_XTENSA_OVERLAY_FILE),)
define LINUX_XTENSA_OVERLAY_EXTRACT
	$(call arch-xtensa-overlay-extract,$(@D),linux)
endef
LINUX_POST_EXTRACT_HOOKS += LINUX_XTENSA_OVERLAY_EXTRACT
LINUX_EXTRA_DOWNLOADS += $(ARCH_XTENSA_OVERLAY_URL)
endif

LINUX_MAKE_FLAGS = \
	HOSTCC="$(HOSTCC)" \
	HOSTCFLAGS="$(HOSTCFLAGS)" \
	ARCH=$(KERNEL_ARCH) \
	INSTALL_MOD_PATH=$(TARGET_DIR) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	DEPMOD=$(HOST_DIR)/sbin/depmod

LINUX_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	BR_BINARIES_DIR=$(BINARIES_DIR)

ifeq ($(BR2_REPRODUCIBLE),y)
LINUX_MAKE_ENV += \
	KBUILD_BUILD_VERSION=1 \
	KBUILD_BUILD_USER=buildroot \
	KBUILD_BUILD_HOST=buildroot \
	KBUILD_BUILD_TIMESTAMP="$(shell LC_ALL=C date -d @$(SOURCE_DATE_EPOCH))"
endif

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
else ifeq ($(BR2_LINUX_KERNEL_ZIMAGE_EPAPR),y)
LINUX_IMAGE_NAME = zImage.epapr
else ifeq ($(BR2_LINUX_KERNEL_APPENDED_ZIMAGE),y)
LINUX_IMAGE_NAME = zImage
else ifeq ($(BR2_LINUX_KERNEL_CUIMAGE),y)
LINUX_IMAGE_NAME = cuImage.$(KERNEL_DTS_NAME)
else ifeq ($(BR2_LINUX_KERNEL_SIMPLEIMAGE),y)
LINUX_IMAGE_NAME = simpleImage.$(KERNEL_DTS_NAME)
else ifeq ($(BR2_LINUX_KERNEL_IMAGE),y)
LINUX_IMAGE_NAME = Image
else ifeq ($(BR2_LINUX_KERNEL_LINUX_BIN),y)
LINUX_IMAGE_NAME = linux.bin
else ifeq ($(BR2_LINUX_KERNEL_VMLINUX_BIN),y)
LINUX_IMAGE_NAME = vmlinux.bin
else ifeq ($(BR2_LINUX_KERNEL_VMLINUX),y)
LINUX_IMAGE_NAME = vmlinux
else ifeq ($(BR2_LINUX_KERNEL_VMLINUZ),y)
LINUX_IMAGE_NAME = vmlinuz
else ifeq ($(BR2_LINUX_KERNEL_VMLINUZ_BIN),y)
LINUX_IMAGE_NAME = vmlinuz.bin
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
else ifeq ($(BR2_LINUX_KERNEL_VMLINUZ_BIN),y)
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

# Older linux kernels use deprecated perl constructs in timeconst.pl
# that were removed for perl 5.22+ so it breaks on newer distributions
# Try a dry-run patch to see if this applies, if it does go ahead
define LINUX_TRY_PATCH_TIMECONST
	@if patch -p1 --dry-run -f -s -d $(@D) <$(LINUX_PKGDIR)/0001-timeconst.pl-Eliminate-Perl-warning.patch.conditional >/dev/null ; then \
		$(APPLY_PATCHES) $(@D) $(LINUX_PKGDIR) 0001-timeconst.pl-Eliminate-Perl-warning.patch.conditional ; \
	fi
endef
LINUX_POST_PATCH_HOOKS += LINUX_TRY_PATCH_TIMECONST

ifeq ($(BR2_LINUX_KERNEL_USE_DEFCONFIG),y)
LINUX_KCONFIG_DEFCONFIG = $(call qstrip,$(BR2_LINUX_KERNEL_DEFCONFIG))_defconfig
else ifeq ($(BR2_LINUX_KERNEL_USE_ARCH_DEFAULT_CONFIG),y)
LINUX_KCONFIG_DEFCONFIG = defconfig
else ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG),y)
LINUX_KCONFIG_FILE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE))
endif
LINUX_KCONFIG_FRAGMENT_FILES = $(call qstrip,$(BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES))
LINUX_KCONFIG_EDITORS = menuconfig xconfig gconfig nconfig
LINUX_KCONFIG_OPTS = $(LINUX_MAKE_FLAGS)

# If no package has yet set it, set it from the Kconfig option
LINUX_NEEDS_MODULES ?= $(BR2_LINUX_NEEDS_MODULES)

# Make sure the Linux kernel is built with the right endianness. Not
# all architectures support
# CONFIG_CPU_BIG_ENDIAN/CONFIG_CPU_LITTLE_ENDIAN in Linux, but the
# option will be thrown away and ignored if it doesn't exist.
ifeq ($(BR2_ENDIAN),"BIG")
define LINUX_FIXUP_CONFIG_ENDIANNESS
	$(call KCONFIG_ENABLE_OPT,CONFIG_CPU_BIG_ENDIAN,$(@D)/.config)
endef
else
define LINUX_FIXUP_CONFIG_ENDIANNESS
	$(call KCONFIG_ENABLE_OPT,CONFIG_CPU_LITTLE_ENDIAN,$(@D)/.config)
endef
endif

define LINUX_KCONFIG_FIXUP_CMDS
	$(if $(LINUX_NEEDS_MODULES),
		$(call KCONFIG_ENABLE_OPT,CONFIG_MODULES,$(@D)/.config))
	$(call KCONFIG_ENABLE_OPT,$(strip $(LINUX_COMPRESSION_OPT_y)),$(@D)/.config)
	$(foreach opt, $(LINUX_COMPRESSION_OPT_),
		$(call KCONFIG_DISABLE_OPT,$(opt),$(@D)/.config)
	)
	$(LINUX_FIXUP_CONFIG_ENDIANNESS)
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
		$(call KCONFIG_ENABLE_OPT,CONFIG_TMPFS_XATTR,$(@D)/.config))
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
		$(call KCONFIG_ENABLE_OPT,CONFIG_NETFILTER_ADVANCED,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_NF_CONNTRACK,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_NF_CONNTRACK_MARK,$(@D)/.config))
	$(if $(BR2_PACKAGE_WIREGUARD),
		$(call KCONFIG_ENABLE_OPT,CONFIG_INET,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_NET,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_NET_FOU,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_CRYPTO,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_CRYPTO_MANAGER,$(@D)/.config))
	$(if $(BR2_LINUX_KERNEL_APPENDED_DTB),
		$(call KCONFIG_ENABLE_OPT,CONFIG_ARM_APPENDED_DTB,$(@D)/.config))
	$(if $(BR2_PACKAGE_KERNEL_MODULE_IMX_GPU_VIV),
		$(call KCONFIG_DISABLE_OPT,CONFIG_MXC_GPU_VIV,$(@D)/.config))
endef

ifeq ($(BR2_LINUX_KERNEL_DTS_SUPPORT),y)
ifeq ($(BR2_LINUX_KERNEL_DTB_IS_SELF_BUILT),)
define LINUX_BUILD_DTB
	$(LINUX_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) $(KERNEL_DTBS)
endef
ifeq ($(BR2_LINUX_KERNEL_APPENDED_DTB),)
define LINUX_INSTALL_DTB
	# dtbs moved from arch/<ARCH>/boot to arch/<ARCH>/boot/dts since 3.8-rc1
	cp $(addprefix \
		$(KERNEL_ARCH_PATH)/boot/$(if $(wildcard \
		$(addprefix $(KERNEL_ARCH_PATH)/boot/dts/,$(KERNEL_DTBS))),dts/),$(KERNEL_DTBS)) \
		$(1)
endef
endif # BR2_LINUX_KERNEL_APPENDED_DTB
endif # BR2_LINUX_KERNEL_DTB_IS_SELF_BUILT
endif # BR2_LINUX_KERNEL_DTS_SUPPORT

ifeq ($(BR2_LINUX_KERNEL_APPENDED_DTB),y)
# dtbs moved from arch/$ARCH/boot to arch/$ARCH/boot/dts since 3.8-rc1
define LINUX_APPEND_DTB
	(cd $(KERNEL_ARCH_PATH)/boot; \
		for dtb in $(KERNEL_DTS_NAME); do \
			if test -e $${dtb}.dtb ; then \
				dtbpath=$${dtb}.dtb ; \
			else \
				dtbpath=dts/$${dtb}.dtb ; \
			fi ; \
			cat zImage $${dtbpath} > zImage.$${dtb} || exit 1; \
		done)
endef
ifeq ($(BR2_LINUX_KERNEL_APPENDED_UIMAGE),y)
# We need to generate a new u-boot image that takes into
# account the extra-size added by the device tree at the end
# of the image. To do so, we first need to retrieve both load
# address and entry point for the kernel from the already
# generate uboot image before using mkimage -l.
LINUX_APPEND_DTB += ; \
	MKIMAGE_ARGS=`$(MKIMAGE) -l $(LINUX_IMAGE_PATH) |\
	sed -n -e 's/Image Name:[ ]*\(.*\)/-n \1/p' -e 's/Load Address:/-a/p' -e 's/Entry Point:/-e/p'`; \
	for dtb in $(KERNEL_DTS_NAME); do \
		$(MKIMAGE) -A $(MKIMAGE_ARCH) -O linux \
			-T kernel -C none $${MKIMAGE_ARGS} \
			-d $(KERNEL_ARCH_PATH)/boot/zImage.$${dtb} $(LINUX_IMAGE_PATH).$${dtb}; \
	done
endif
endif

# Compilation. We make sure the kernel gets rebuilt when the
# configuration has changed.
define LINUX_BUILD_CMDS
	$(if $(BR2_LINUX_KERNEL_USE_CUSTOM_DTS),
		cp -f $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_DTS_PATH)) $(KERNEL_ARCH_PATH)/boot/dts/)
	$(LINUX_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) $(LINUX_TARGET_NAME)
	@if grep -q "CONFIG_MODULES=y" $(@D)/.config; then	\
		$(LINUX_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) modules ;	\
	fi
	$(LINUX_BUILD_DTB)
	$(LINUX_APPEND_DTB)
endef

ifeq ($(BR2_LINUX_KERNEL_APPENDED_DTB),y)
# When a DTB was appended, install the potential several images with
# appended DTBs.
define LINUX_INSTALL_IMAGE
	mkdir -p $(1)
	cp $(KERNEL_ARCH_PATH)/boot/$(LINUX_IMAGE_NAME).* $(1)
endef
else
# Otherwise, just install the unique image generated by the kernel
# build process.
define LINUX_INSTALL_IMAGE
	$(INSTALL) -m 0644 -D $(LINUX_IMAGE_PATH) $(1)/$(LINUX_IMAGE_NAME)
endef
endif

ifeq ($(BR2_LINUX_KERNEL_INSTALL_TARGET),y)
define LINUX_INSTALL_KERNEL_IMAGE_TO_TARGET
	$(call LINUX_INSTALL_IMAGE,$(TARGET_DIR)/boot)
	$(call LINUX_INSTALL_DTB,$(TARGET_DIR)/boot)
endef
endif

define LINUX_INSTALL_HOST_TOOLS
	# Installing dtc (device tree compiler) as host tool, if selected
	if grep -q "CONFIG_DTC=y" $(@D)/.config; then	\
		$(INSTALL) -D -m 0755 $(@D)/scripts/dtc/dtc $(HOST_DIR)/bin/linux-dtc ;	\
		if [ ! -e $(HOST_DIR)/bin/dtc ]; then	\
			ln -sf linux-dtc $(HOST_DIR)/bin/dtc ;	\
		fi	\
	fi
endef


define LINUX_INSTALL_IMAGES_CMDS
	$(call LINUX_INSTALL_IMAGE,$(BINARIES_DIR))
	$(call LINUX_INSTALL_DTB,$(BINARIES_DIR))
endef

ifeq ($(BR2_STRIP_strip),y)
LINUX_MAKE_FLAGS += INSTALL_MOD_STRIP=1
endif

define LINUX_INSTALL_TARGET_CMDS
	$(LINUX_INSTALL_KERNEL_IMAGE_TO_TARGET)
	# Install modules and remove symbolic links pointing to build
	# directories, not relevant on the target
	@if grep -q "CONFIG_MODULES=y" $(@D)/.config; then	\
		$(LINUX_MAKE_ENV) $(MAKE1) $(LINUX_MAKE_FLAGS) -C $(@D) modules_install; \
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/build ;		\
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/source ;	\
	fi
	$(LINUX_INSTALL_HOST_TOOLS)
endef

# Include all our extensions.
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

LINUX_PATCH_DEPENDENCIES += $(foreach ext,$(LINUX_EXTENSIONS),\
	$(if $(BR2_LINUX_KERNEL_EXT_$(call UPPERCASE,$(ext))),$(ext)))

LINUX_PRE_PATCH_HOOKS += $(foreach ext,$(LINUX_EXTENSIONS),\
	$(if $(BR2_LINUX_KERNEL_EXT_$(call UPPERCASE,$(ext))),\
		$(call UPPERCASE,$(ext))_PREPARE_KERNEL))

# Checks to give errors that the user can understand

# When a custom repository has been set, check for the repository version
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_SVN)$(BR2_LINUX_KERNEL_CUSTOM_GIT)$(BR2_LINUX_KERNEL_CUSTOM_HG),y)
ifeq ($(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION)),)
$(error No custom repository version set. Check your BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION setting)
endif
ifeq ($(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL)),)
$(error No custom repo URL set. Check your BR2_LINUX_KERNEL_CUSTOM_REPO_URL setting)
endif
endif

ifeq ($(BR_BUILDING),y)

ifeq ($(BR2_LINUX_KERNEL_USE_DEFCONFIG),y)
# We must use the user-supplied kconfig value, because
# LINUX_KCONFIG_DEFCONFIG will at least contain the
# trailing _defconfig
ifeq ($(call qstrip,$(BR2_LINUX_KERNEL_DEFCONFIG)),)
$(error No kernel defconfig name specified, check your BR2_LINUX_KERNEL_DEFCONFIG setting)
endif
endif

ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG),y)
ifeq ($(LINUX_KCONFIG_FILE),)
$(error No kernel configuration file specified, check your BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE setting)
endif
endif

ifeq ($(BR2_LINUX_KERNEL_DTS_SUPPORT)$(KERNEL_DTS_NAME),y)
$(error No kernel device tree source specified, check your \
BR2_LINUX_KERNEL_USE_INTREE_DTS / BR2_LINUX_KERNEL_USE_CUSTOM_DTS settings)
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
	# Copy the kernel image(s) to its(their) final destination
	$(call LINUX_INSTALL_IMAGE,$(BINARIES_DIR))
	# If there is a .ub file copy it to the final destination
	test ! -f $(LINUX_IMAGE_PATH).ub || cp $(LINUX_IMAGE_PATH).ub $(BINARIES_DIR)
	$(Q)touch $@

# The initramfs building code must make sure this target gets called
# after it generated the initramfs list of files.
linux-rebuild-with-initramfs: $(LINUX_DIR)/.stamp_initramfs_rebuilt
