#
# Macro that builds the needed Makefile target to create a root
# filesystem image.
#
# The following variable must be defined before calling this macro
#
#  ROOTFS_$(FSTYPE)_CMD, the command that generates the root
#  filesystem image. A single command is allowed. The filename of the
#  filesystem image that it must generate is $$@.
#
# The following variables can optionaly be defined
#
#  ROOTFS_$(FSTYPE)_DEPENDENCIES, the list of dependencies needed to
#  build the root filesystem (usually host tools)
#
#  ROOTFS_$(FSTYPE)_PRE_GEN_HOOKS, a list of hooks to call before
#  generating the filesystem image
#
#  ROOTFS_$(FSTYPE)_POST_GEN_HOOKS, a list of hooks to call after
#  generating the filesystem image
#
# In terms of configuration option, this macro assumes that the
# BR2_TARGET_ROOTFS_$(FSTYPE) config option allows to enable/disable
# the generation of a filesystem image of a particular type. If
# the configuration options BR2_TARGET_ROOTFS_$(FSTYPE)_GZIP,
# BR2_TARGET_ROOTFS_$(FSTYPE)_BZIP2 or
# BR2_TARGET_ROOTFS_$(FSTYPE)_LZMA exist and are enabled, then the
# macro will automatically generate a compressed filesystem image.

FS_DIR = $(BUILD_DIR)/buildroot-fs
ROOTFS_DEVICE_TABLES = $(call qstrip,$(BR2_ROOTFS_DEVICE_TABLE) \
	$(BR2_ROOTFS_STATIC_DEVICE_TABLE))

ROOTFS_USERS_TABLES = $(call qstrip,$(BR2_ROOTFS_USERS_TABLES))

ROOTFS_FULL_DEVICES_TABLE = $(FS_DIR)/full_devices_table.txt
ROOTFS_FULL_USERS_TABLE = $(FS_DIR)/full_users_table.txt

ifeq ($(BR2_REPRODUCIBLE),y)
define ROOTFS_REPRODUCIBLE
	find $(TARGET_DIR) -print0 | xargs -0 -r touch -hd @$(SOURCE_DATE_EPOCH)
endef
endif

ROOTFS_COMMON_DEPENDENCIES = \
	host-fakeroot host-makedevs \
	$(BR2_TAR_HOST_DEPENDENCY) \
	$(if $(PACKAGES_USERS)$(ROOTFS_USERS_TABLES),host-mkpasswd)

.PHONY: rootfs-common
rootfs-common: $(ROOTFS_COMMON_DEPENDENCIES) target-finalize
	@$(call MESSAGE,"Generating root filesystems common tables")
	rm -rf $(FS_DIR)
	mkdir -p $(FS_DIR)

	$(call PRINTF,$(PACKAGES_USERS)) >> $(ROOTFS_FULL_USERS_TABLE)
ifneq ($(ROOTFS_USERS_TABLES),)
	cat $(ROOTFS_USERS_TABLES) >> $(ROOTFS_FULL_USERS_TABLE)
endif

	$(call PRINTF,$(PACKAGES_PERMISSIONS_TABLE)) > $(ROOTFS_FULL_DEVICES_TABLE)
ifneq ($(ROOTFS_DEVICE_TABLES),)
	cat $(ROOTFS_DEVICE_TABLES) >> $(ROOTFS_FULL_DEVICES_TABLE)
endif
ifeq ($(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)
	$(call PRINTF,$(PACKAGES_DEVICES_TABLE)) >> $(ROOTFS_FULL_DEVICES_TABLE)
endif

rootfs-common-show-depends:
	@echo $(ROOTFS_COMMON_DEPENDENCIES)

# Since this function will be called from within an $(eval ...)
# all variable references except the arguments must be $$-quoted.
define inner-rootfs

ROOTFS_$(2)_IMAGE_NAME ?= rootfs.$(1)
ROOTFS_$(2)_FINAL_IMAGE_NAME = $$(strip $$(ROOTFS_$(2)_IMAGE_NAME))
ROOTFS_$(2)_DIR = $$(FS_DIR)/$(1)
ROOTFS_$(2)_TARGET_DIR = $$(ROOTFS_$(2)_DIR)/target

ROOTFS_$(2)_DEPENDENCIES += rootfs-common

ifeq ($$(BR2_TARGET_ROOTFS_$(2)_GZIP),y)
ROOTFS_$(2)_COMPRESS_EXT = .gz
ROOTFS_$(2)_COMPRESS_CMD = gzip -9 -c
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_BZIP2),y)
ROOTFS_$(2)_COMPRESS_EXT = .bz2
ROOTFS_$(2)_COMPRESS_CMD = bzip2 -9 -c
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZMA),y)
ROOTFS_$(2)_DEPENDENCIES += host-lzma
ROOTFS_$(2)_COMPRESS_EXT = .lzma
ROOTFS_$(2)_COMPRESS_CMD = $$(LZMA) -9 -c
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZ4),y)
ROOTFS_$(2)_DEPENDENCIES += host-lz4
ROOTFS_$(2)_COMPRESS_EXT = .lz4
ROOTFS_$(2)_COMPRESS_CMD = lz4 -l -9 -c
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZO),y)
ROOTFS_$(2)_DEPENDENCIES += host-lzop
ROOTFS_$(2)_COMPRESS_EXT = .lzo
ROOTFS_$(2)_COMPRESS_CMD = $$(LZOP) -9 -c
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_XZ),y)
ROOTFS_$(2)_DEPENDENCIES += host-xz
ROOTFS_$(2)_COMPRESS_EXT = .xz
ROOTFS_$(2)_COMPRESS_CMD = xz -9 -C crc32 -c
endif

$$(BINARIES_DIR)/$$(ROOTFS_$(2)_FINAL_IMAGE_NAME): ROOTFS=$(2)
$$(BINARIES_DIR)/$$(ROOTFS_$(2)_FINAL_IMAGE_NAME): FAKEROOT_SCRIPT=$$(ROOTFS_$(2)_DIR)/fakeroot
$$(BINARIES_DIR)/$$(ROOTFS_$(2)_FINAL_IMAGE_NAME): $$(ROOTFS_$(2)_DEPENDENCIES)
	@$$(call MESSAGE,"Generating filesystem image $$(ROOTFS_$(2)_FINAL_IMAGE_NAME)")
	mkdir -p $$(@D)
	rm -rf $$(ROOTFS_$(2)_DIR)
	mkdir -p $$(ROOTFS_$(2)_DIR)
	rsync -auH \
		--exclude=/$$(notdir $$(TARGET_DIR_WARNING_FILE)) \
		$$(BASE_TARGET_DIR)/ \
		$$(TARGET_DIR)

	echo '#!/bin/sh' > $$(FAKEROOT_SCRIPT)
	echo "set -e" >> $$(FAKEROOT_SCRIPT)

	echo "chown -h -R 0:0 $$(TARGET_DIR)" >> $$(FAKEROOT_SCRIPT)
	PATH=$$(BR_PATH) $$(TOPDIR)/support/scripts/mkusers $$(ROOTFS_FULL_USERS_TABLE) $$(TARGET_DIR) >> $$(FAKEROOT_SCRIPT)
	echo "$$(HOST_DIR)/bin/makedevs -d $$(ROOTFS_FULL_DEVICES_TABLE) $$(TARGET_DIR)" >> $$(FAKEROOT_SCRIPT)
	$$(foreach s,$$(call qstrip,$$(BR2_ROOTFS_POST_FAKEROOT_SCRIPT)),\
		echo "echo '$$(TERM_BOLD)>>>   Executing fakeroot script $$(s)$$(TERM_RESET)'" >> $$(FAKEROOT_SCRIPT); \
		echo $$(EXTRA_ENV) $$(s) $$(TARGET_DIR) $$(BR2_ROOTFS_POST_SCRIPT_ARGS) >> $$(FAKEROOT_SCRIPT)$$(sep))
	$$(foreach hook,$$(ROOTFS_PRE_CMD_HOOKS),\
		$$(call PRINTF,$$($$(hook))) >> $$(FAKEROOT_SCRIPT)$$(sep))

	$$(foreach hook,$$(ROOTFS_$(2)_PRE_GEN_HOOKS),\
		$$(call PRINTF,$$($$(hook))) >> $$(FAKEROOT_SCRIPT)$$(sep))
	$$(call PRINTF,$$(ROOTFS_REPRODUCIBLE)) >> $$(FAKEROOT_SCRIPT)
	$$(call PRINTF,$$(ROOTFS_$(2)_CMD)) >> $$(FAKEROOT_SCRIPT)
	chmod a+x $$(FAKEROOT_SCRIPT)
	PATH=$$(BR_PATH) $$(HOST_DIR)/bin/fakeroot -- $$(FAKEROOT_SCRIPT)
	$(Q)rm -rf $$(TARGET_DIR)
ifneq ($$(ROOTFS_$(2)_COMPRESS_CMD),)
	PATH=$$(BR_PATH) $$(ROOTFS_$(2)_COMPRESS_CMD) $$@ > $$@$$(ROOTFS_$(2)_COMPRESS_EXT)
endif
	$$(foreach hook,$$(ROOTFS_$(2)_POST_GEN_HOOKS),$$(call $$(hook))$$(sep))

rootfs-$(1)-show-depends:
	@echo $$(ROOTFS_$(2)_DEPENDENCIES)

rootfs-$(1): $$(BINARIES_DIR)/$$(ROOTFS_$(2)_FINAL_IMAGE_NAME)

.PHONY: rootfs-$(1) rootfs-$(1)-show-depends

ifeq ($$(BR2_TARGET_ROOTFS_$(2)),y)
TARGETS_ROOTFS += rootfs-$(1)
PACKAGES += $$(filter-out rootfs-%,$$(ROOTFS_$(2)_DEPENDENCIES) $$(ROOTFS_COMMON_DEPENDENCIES))
endif

# Check for legacy POST_TARGETS rules
ifneq ($$(ROOTFS_$(2)_POST_TARGETS),)
$$(error Filesystem $(1) uses post-target rules, which are no longer supported.\
	Update $(1) to use post-gen hooks instead)
endif

endef

# $(pkgname) also works well to return the filesystem name
rootfs = $(call inner-rootfs,$(pkgname),$(call UPPERCASE,$(pkgname)))

include $(sort $(wildcard fs/*/*.mk))
