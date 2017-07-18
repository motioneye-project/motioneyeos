################################################################################
#
# system-related variables and macros
#
################################################################################

# This file exists to define variables and macros that pertain to the system
# settings, like rsyncing a directory for skeletons, or the /lib vs. /usr/lib
# symlink handling.
#
# Some variables may be used as conditions in Makefile code, so they must be
# defined properly before they are used; this file is included early, before
# any package is.

# - SYSTEM_USR_SYMLINKS_OR_DIRS
#   create /lib, /bin and /sbin, either as directories or as symlinks to
#   their /usr conterparts
#
# - SYSTEM_RSYNC
#   rsync $(1) to $(2), with proper exclusions and rights
#
# - SYSTEM_LIB_SYMLINK
#   create the appropriate /lib{32,64} symlinks
#
# - SYSTEM_GETTY_PORT
# - SYSTEM_GETTY_BAUDRATE
# - SYSTEM_GETTY_TERM
# - SYSTEM_GETTY_OPTIONS
#   the un-quoted getty setting
#
# - SYSTEM_REMOUNT_ROOT_INITTAB
#   set inittab to remount root read-write or read-only
#

# This function handles the merged or non-merged /usr cases
ifeq ($(BR2_ROOTFS_MERGED_USR),y)
define SYSTEM_USR_SYMLINKS_OR_DIRS
	ln -snf usr/bin $(1)/bin
	ln -snf usr/sbin $(1)/sbin
	ln -snf usr/lib $(1)/lib
endef
else
define SYSTEM_USR_SYMLINKS_OR_DIRS
	$(INSTALL) -d -m 0755 $(1)/bin
	$(INSTALL) -d -m 0755 $(1)/sbin
	$(INSTALL) -d -m 0755 $(1)/lib
endef
endif

# This function rsyncs the skeleton directory in $(1) to the destination
# in $(2), which should be either $(TARTGET_DIR) or $(STAGING_DIR)
define SYSTEM_RSYNC
	rsync -a --ignore-times $(RSYNC_VCS_EXCLUSIONS) \
		--chmod=u=rwX,go=rX --exclude .empty --exclude '*~' \
		$(1)/ $(2)/
endef

# Make a symlink lib32->lib or lib64->lib as appropriate.
# MIPS64/n32 requires lib32 even though it's a 64-bit arch.
# $(1): base dir (either staging or target)
ifeq ($(BR2_ARCH_IS_64)$(BR2_MIPS_NABI32),y)
define SYSTEM_LIB_SYMLINK
	ln -snf lib $(1)/lib64
	ln -snf lib $(1)/usr/lib64
endef
else
define SYSTEM_LIB_SYMLINK
	ln -snf lib $(1)/lib32
	ln -snf lib $(1)/usr/lib32
endef
endif

SYSTEM_GETTY_PORT = $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT))
SYSTEM_GETTY_BAUDRATE = $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE))
SYSTEM_GETTY_TERM = $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_TERM))
SYSTEM_GETTY_OPTIONS = $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_OPTIONS))

ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)
# Find commented line, if any, and remove leading '#'s
define SYSTEM_REMOUNT_ROOT_INITTAB
	$(SED) '/^#.*-o remount,rw \/$$/s~^#\+~~' $(TARGET_DIR)/etc/inittab
endef
else
# Find uncommented line, if any, and add a leading '#'
define SYSTEM_REMOUNT_ROOT_INITTAB
	$(SED) '/^[^#].*-o remount,rw \/$$/s~^~#~' $(TARGET_DIR)/etc/inittab
endef
endif
