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
ROOTFS_DEVICE_TABLES = $(call qstrip,$(BR2_ROOTFS_DEVICE_TABLE)) \
	$(call qstrip,$(BR2_ROOTFS_STATIC_DEVICE_TABLE))

define ROOTFS_TARGET_INTERNAL

# extra deps
$(eval ROOTFS_$(2)_DEPENDENCIES += host-fakeroot host-makedevs $(if $(BR2_TARGET_ROOTFS_$(2)_LZMA),host-lzma))

$(BINARIES_DIR)/rootfs.$(1): $(ROOTFS_$(2)_DEPENDENCIES)
	@$(call MESSAGE,"Generating root filesystem image rootfs.$(1)")
	$(foreach hook,$(ROOTFS_$(2)_PRE_GEN_HOOKS),$(call $(hook))$(sep))
	rm -f $(FAKEROOT_SCRIPT)
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
ifneq ($(ROOTFS_DEVICE_TABLES),)
	cat $(ROOTFS_DEVICE_TABLES) > $(FULL_DEVICE_TABLE)
ifeq ($(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)
	echo -e '$(subst $(sep),\n,$(PACKAGES_DEVICES_TABLE))' >> $(FULL_DEVICE_TABLE)
endif
	echo -e '$(subst $(sep),\n,$(PACKAGES_PERMISSIONS_TABLE))' >> $(FULL_DEVICE_TABLE)
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(FULL_DEVICE_TABLE) $(TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
endif
	echo "$(ROOTFS_$(2)_CMD)" >> $(FAKEROOT_SCRIPT)
	chmod a+x $(FAKEROOT_SCRIPT)
	$(HOST_DIR)/usr/bin/fakeroot -- $(FAKEROOT_SCRIPT)
	-@rm -f $(FAKEROOT_SCRIPT) $(FULL_DEVICE_TABLE)
	$(foreach hook,$(ROOTFS_$(2)_POST_GEN_HOOKS),$(call $(hook))$(sep))
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_GZIP),y)
	gzip -9 -c $$@ > $$@.gz
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_BZIP2),y)
	bzip2 -9 -c $$@ > $$@.bz2
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZMA),y)
	$(LZMA) -9 -c $$@ > $$@.lzma
endif

rootfs-$(1)-show-depends:
	@echo $(ROOTFS_$(2)_DEPENDENCIES)

rootfs-$(1): $(BINARIES_DIR)/rootfs.$(1) $(ROOTFS_$(2)_POST_TARGETS)

ifeq ($$(BR2_TARGET_ROOTFS_$(2)),y)
TARGETS += rootfs-$(1)
endif
endef

define ROOTFS_TARGET
$(call ROOTFS_TARGET_INTERNAL,$(1),$(call UPPERCASE,$(1)))
endef

include fs/*/*.mk
