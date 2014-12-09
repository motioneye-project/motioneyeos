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
#  ROOTFS_$(FSTYPE)_POST_TARGETS, the list of targets that should be
#  run after running the main filesystem target. This is useful for
#  initramfs, to rebuild the kernel once the initramfs is generated.
#
# In terms of configuration option, this macro assumes that the
# BR2_TARGET_ROOTFS_$(FSTYPE) config option allows to enable/disable
# the generation of a filesystem image of a particular type. If
# configura options BR2_TARGET_ROOTFS_$(FSTYPE)_GZIP,
# BR2_TARGET_ROOTFS_$(FSTYPE)_BZIP2 or
# BR2_TARGET_ROOTFS_$(FSTYPE)_LZMA exist and are enabled, then the
# macro will automatically generate a compressed filesystem image.

FAKEROOT_SCRIPT = $(BUILD_DIR)/_fakeroot.fs
FULL_DEVICE_TABLE = $(BUILD_DIR)/_device_table.txt
ROOTFS_DEVICE_TABLES = $(call qstrip,$(BR2_ROOTFS_DEVICE_TABLE) \
	$(BR2_ROOTFS_STATIC_DEVICE_TABLE))
USERS_TABLE = $(BUILD_DIR)/_users_table.txt
ROOTFS_USERS_TABLES = $(call qstrip,$(BR2_ROOTFS_USERS_TABLES))

# Since this function will be called from within an $(eval ...)
# all variable references except the arguments must be $$-quoted.
define ROOTFS_TARGET_INTERNAL

# extra deps
ROOTFS_$(2)_DEPENDENCIES += host-fakeroot host-makedevs \
	$$(if $$(PACKAGES_USERS),host-mkpasswd)

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
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZO),y)
ROOTFS_$(2)_DEPENDENCIES += host-lzop
ROOTFS_$(2)_COMPRESS_EXT = .lzo
ROOTFS_$(2)_COMPRESS_CMD = $$(LZOP) -9 -c
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_XZ),y)
ROOTFS_$(2)_COMPRESS_EXT = .xz
ROOTFS_$(2)_COMPRESS_CMD = xz -9 -C crc32 -c
endif

$$(BINARIES_DIR)/rootfs.$(1): target-finalize $$(ROOTFS_$(2)_DEPENDENCIES)
	@$$(call MESSAGE,"Generating root filesystem image rootfs.$(1)")
	$$(foreach hook,$$(ROOTFS_$(2)_PRE_GEN_HOOKS),$$(call $$(hook))$$(sep))
	rm -f $$(FAKEROOT_SCRIPT)
	rm -f $$(TARGET_DIR_WARNING_FILE)
	rm -f $$(USERS_TABLE)
	echo "chown -h -R 0:0 $$(TARGET_DIR)" >> $$(FAKEROOT_SCRIPT)
ifneq ($$(ROOTFS_DEVICE_TABLES),)
	cat $$(ROOTFS_DEVICE_TABLES) > $$(FULL_DEVICE_TABLE)
ifeq ($$(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)
	printf '$$(subst $$(sep),\n,$$(PACKAGES_DEVICES_TABLE))' >> $$(FULL_DEVICE_TABLE)
endif
	printf '$$(subst $$(sep),\n,$$(PACKAGES_PERMISSIONS_TABLE))' >> $$(FULL_DEVICE_TABLE)
	echo "$$(HOST_DIR)/usr/bin/makedevs -d $$(FULL_DEVICE_TABLE) $$(TARGET_DIR)" >> $$(FAKEROOT_SCRIPT)
endif
ifneq ($$(ROOTFS_USERS_TABLES),)
	cat $$(ROOTFS_USERS_TABLES) >> $$(USERS_TABLE)
endif
	printf '$$(subst $$(sep),\n,$$(PACKAGES_USERS))' >> $$(USERS_TABLE)
	PATH=$$(BR_PATH) $$(TOPDIR)/support/scripts/mkusers $$(USERS_TABLE) $$(TARGET_DIR) >> $$(FAKEROOT_SCRIPT)
	echo "$$(ROOTFS_$(2)_CMD)" >> $$(FAKEROOT_SCRIPT)
	chmod a+x $$(FAKEROOT_SCRIPT)
	PATH=$$(BR_PATH) $$(HOST_DIR)/usr/bin/fakeroot -- $$(FAKEROOT_SCRIPT)
	$$(INSTALL) -m 0644 support/misc/target-dir-warning.txt $$(TARGET_DIR_WARNING_FILE)
	-@rm -f $$(FAKEROOT_SCRIPT) $$(FULL_DEVICE_TABLE)
ifneq ($$(ROOTFS_$(2)_COMPRESS_CMD),)
	PATH=$$(BR_PATH) $$(ROOTFS_$(2)_COMPRESS_CMD) $$@ > $$@$$(ROOTFS_$(2)_COMPRESS_EXT)
endif

rootfs-$(1)-show-depends:
	@echo $$(ROOTFS_$(2)_DEPENDENCIES)

rootfs-$(1): $$(BINARIES_DIR)/rootfs.$(1) $$(ROOTFS_$(2)_POST_TARGETS)

ifeq ($$(BR2_TARGET_ROOTFS_$(2)),y)
TARGETS_ROOTFS += rootfs-$(1)
endif
endef

define ROOTFS_TARGET
	$(call ROOTFS_TARGET_INTERNAL,$(1),$(call UPPERCASE,$(1)))
endef

include $(sort $(wildcard fs/*/*.mk))
