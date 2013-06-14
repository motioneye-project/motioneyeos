################################################################################
#
# dosfstools
#
################################################################################

DOSFSTOOLS_VERSION = 3.0.20
DOSFSTOOLS_SITE = http://daniel-baumann.ch/files/software/dosfstools
DOSFSTOOLS_LICENSE = GPLv3+
DOSFSTOOLS_LICENSE_FILES = COPYING
DOSFSTOOLS_LDFLAGS = $(TARGET_LDFLAGS)

# Avoid target dosfstools dependencies, no host-libiconv
HOST_DOSFSTOOLS_DEPENDENCIES =

ifneq ($(BR2_ENABLE_LOCALE),y)
DOSFSTOOLS_DEPENDENCIES += libiconv
DOSFSTOOLS_LDFLAGS += -liconv
endif

FATLABEL_BINARY = fatlabel
FSCK_FAT_BINARY = fsck.fat
MKFS_FAT_BINARY = mkfs.fat

define DOSFSTOOLS_BUILD_CMDS
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" CC="$(TARGET_CC)" \
		LDFLAGS="$(DOSFSTOOLS_LDFLAGS)" -C $(@D)
endef

DOSFSTOOLS_INSTALL_BIN_FILES_$(BR2_PACKAGE_DOSFSTOOLS_FATLABEL)+=$(FATLABEL_BINARY)
DOSFSTOOLS_INSTALL_BIN_FILES_$(BR2_PACKAGE_DOSFSTOOLS_FSCK_FAT)+=$(FSCK_FAT_BINARY)
DOSFSTOOLS_INSTALL_BIN_FILES_$(BR2_PACKAGE_DOSFSTOOLS_MKFS_FAT)+=$(MKFS_FAT_BINARY)

define DOSFSTOOLS_INSTALL_TARGET_CMDS
	test -z "$(DOSFSTOOLS_INSTALL_BIN_FILES_y)" || \
	$(INSTALL) -m 755 $(addprefix $(@D)/,$(DOSFSTOOLS_INSTALL_BIN_FILES_y)) \
		$(TARGET_DIR)/sbin/
endef

define DOSFSTOOLS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/sbin/$(FATLABEL_BINARY)
	rm -f $(TARGET_DIR)/sbin/$(FSCK_FAT_BINARY)
	rm -f $(TARGET_DIR)/sbin/$(MKFS_FAT_BINARY)
endef

define DOSFSTOOLS_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

define HOST_DOSFSTOOLS_BUILD_CMDS
	$(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D)
endef

define HOST_DOSFSTOOLS_INSTALL_CMDS
	$(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) PREFIX=$(HOST_DIR)/usr install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
