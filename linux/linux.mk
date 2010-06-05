###############################################################################
#
# Linux kernel 2.6 target
#
###############################################################################
LINUX26_VERSION=$(call qstrip,$(BR2_LINUX_KERNEL_VERSION))

# Compute LINUX26_SOURCE and LINUX26_SITE from the configuration
ifeq ($(LINUX26_VERSION),custom)
LINUX26_TARBALL:=$(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
LINUX26_SITE:=$(dir $(LINUX26_TARBALL))
LINUX26_SOURCE:=$(notdir $(LINUX26_TARBALL))
else
LINUX26_SOURCE:=linux-$(LINUX26_VERSION).tar.bz2
LINUX26_SITE:=$(BR2_KERNEL_MIRROR)/linux/kernel/v2.6/
endif

LINUX26_DIR:=$(BUILD_DIR)/linux-$(LINUX26_VERSION)
LINUX26_PATCH=$(call qstrip,$(BR2_LINUX_KERNEL_PATCH))

LINUX26_MAKE_FLAGS = \
	HOSTCC="$(HOSTCC)" \
	HOSTCFLAGS="$(HOSTCFLAGS)" \
	ARCH=$(KERNEL_ARCH) \
	INSTALL_MOD_PATH=$(TARGET_DIR) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LZMA="$(LZMA)"

# Get the real Linux version, which tells us where kernel modules are
# going to be installed in the target filesystem.
LINUX26_VERSION_PROBED = $(shell $(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) --no-print-directory -s kernelrelease)

ifeq ($(BR2_LINUX_KERNEL_UIMAGE),y)
LINUX26_IMAGE_NAME=uImage
LINUX26_DEPENDENCIES+=$(MKIMAGE)
else ifeq ($(BR2_LINUX_KERNEL_BZIMAGE),y)
LINUX26_IMAGE_NAME=bzImage
else ifeq ($(BR2_LINUX_KERNEL_ZIMAGE),y)
LINUX26_IMAGE_NAME=zImage
else ifeq ($(BR2_LINUX_KERNEL_VMLINUX),y)
LINUX26_IMAGE_NAME=vmlinux.bin
endif

LINUX26_IMAGE_PATH=$(LINUX26_DIR)/arch/$(KERNEL_ARCH)/boot/$(LINUX26_IMAGE_NAME)

# Download
$(LINUX26_DIR)/.stamp_downloaded:
	@$(call MESSAGE,"Downloading kernel")
	$(call DOWNLOAD,$(LINUX26_SITE),$(LINUX26_SOURCE))
ifneq ($(filter ftp://% http://%,$(LINUX26_PATCH)),)
	$(call DOWNLOAD,$(dir $(LINUX26_PATCH)),$(notdir $(LINUX26_PATCH)))
endif
	mkdir -p $(@D)
	touch $@

# Extraction
$(LINUX26_DIR)/.stamp_extracted: $(LINUX26_DIR)/.stamp_downloaded
	@$(call MESSAGE,"Extracting kernel")
	mkdir -p $(@D)
	$(Q)$(INFLATE$(suffix $(LINUX26_SOURCE))) $(DL_DIR)/$(LINUX26_SOURCE) | \
		tar -C $(@D) $(TAR_STRIP_COMPONENTS)=1 $(TAR_OPTIONS) -
	$(Q)touch $@

# Patch
$(LINUX26_DIR)/.stamp_patched: $(LINUX26_DIR)/.stamp_extracted
	@$(call MESSAGE,"Patching kernel")
ifneq ($(LINUX26_PATCH),)
ifneq ($(filter ftp://% http://%,$(LINUX26_PATCH)),)
	toolchain/patch-kernel.sh $(@D) $(DL_DIR) $(notdir $(LINUX26_PATCH))
else ifeq ($(shell test -d $(LINUX26_PATCH) && echo "dir"),dir)
	toolchain/patch-kernel.sh $(@D) $(LINUX26_PATCH) linux-\*.patch
else
	toolchain/patch-kernel.sh $(@D) $(dir $(LINUX26_PATCH)) $(notdir $(LINUX26_PATCH))
endif
endif
	$(Q)touch $@


# Configuration
$(LINUX26_DIR)/.stamp_configured: $(LINUX26_DIR)/.stamp_patched
	@$(call MESSAGE,"Configuring kernel")
ifeq ($(BR2_LINUX_KERNEL_USE_DEFCONFIG),y)
	$(TARGET_MAKE_ENV) $(MAKE1) $(LINUX26_MAKE_FLAGS) -C $(@D) $(call qstrip,$(BR2_LINUX_KERNEL_DEFCONFIG))_defconfig
else ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG),y)
	cp $(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE) $(@D)/.config
endif
	$(TARGET_MAKE_ENV) $(MAKE) $(LINUX26_MAKE_FLAGS) -C $(@D) oldconfig
	$(Q)touch $@

# Compilation
$(LINUX26_DIR)/.stamp_compiled: $(LINUX26_DIR)/.stamp_configured
	@$(call MESSAGE,"Compiling kernel")
	$(TARGET_MAKE_ENV) $(MAKE) $(LINUX26_MAKE_FLAGS) -C $(@D) $(LINUX26_IMAGE_NAME)
	@if [ $(shell grep -c "CONFIG_MODULES=y" $(LINUX26_DIR)/.config) != 0 ] ; then 	\
		$(TARGET_MAKE_ENV) $(MAKE) $(LINUX26_MAKE_FLAGS) -C $(@D) modules ;	\
	fi
	$(Q)touch $@

# Installation
$(LINUX26_DIR)/.stamp_installed: $(LINUX26_DIR)/.stamp_compiled
	@$(call MESSAGE,"Installing kernel")
	cp $(LINUX26_IMAGE_PATH) $(BINARIES_DIR)
	# Install modules and remove symbolic links pointing to build
	# directories, not relevant on the target
	@if [ $(shell grep -c "CONFIG_MODULES=y" $(LINUX26_DIR)/.config) != 0 ] ; then 	\
		$(TARGET_MAKE_ENV) $(MAKE1) $(LINUX26_MAKE_FLAGS) -C $(@D) 		\
			INSTALL_MOD_PATH=$(TARGET_DIR) modules_install ;		\
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION_PROBED)/build ;	\
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION_PROBED)/source ;	\
	fi
	$(Q)touch $@

linux26: host-module-init-tools $(LINUX26_DEPENDENCIES) $(LINUX26_DIR)/.stamp_installed

ifeq ($(BR2_LINUX_KERNEL),y)
TARGETS+=linux26
endif
