################################################################################
#
# dosfstools
#
################################################################################

DOSFSTOOLS_VERSION = 3.0.26
DOSFSTOOLS_SOURCE = dosfstools-$(DOSFSTOOLS_VERSION).tar.xz
DOSFSTOOLS_SITE = http://daniel-baumann.ch/files/software/dosfstools
DOSFSTOOLS_LICENSE = GPLv3+
DOSFSTOOLS_LICENSE_FILES = COPYING

# Avoid target dosfstools dependencies, no host-libiconv
HOST_DOSFSTOOLS_DEPENDENCIES =

DOSFSTOOLS_CFLAGS = $(TARGET_CFLAGS) -D_GNU_SOURCE

ifneq ($(BR2_ENABLE_LOCALE),y)
DOSFSTOOLS_DEPENDENCIES += libiconv
DOSFSTOOLS_LDLIBS += -liconv
endif

define DOSFSTOOLS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(DOSFSTOOLS_CFLAGS)" LDLIBS="$(DOSFSTOOLS_LDLIBS)" -C $(@D)
endef

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_FATLABEL),y)
define DOSFSTOOLS_INSTALL_FATLABEL
	$(INSTALL) -D -m 755 $(@D)/fatlabel $(TARGET_DIR)/sbin/fatlabel
	ln -sf fatlabel $(TARGET_DIR)/sbin/dosfslabel
endef
endif

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_FSCK_FAT),y)
define DOSFSTOOLS_INSTALL_FSCK_FAT
	$(INSTALL) -D -m 755 $(@D)/fsck.fat $(TARGET_DIR)/sbin/fsck.fat
	ln -fs fsck.fat $(TARGET_DIR)/sbin/dosfsck
	ln -fs fsck.fat $(TARGET_DIR)/sbin/fsck.msdos
	ln -fs fsck.fat $(TARGET_DIR)/sbin/fsck.vfat
endef
endif

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_MKFS_FAT),y)
define DOSFSTOOLS_INSTALL_MKFS_FAT
	$(INSTALL) -D -m 755 $(@D)/mkfs.fat $(TARGET_DIR)/sbin/mkfs.fat
	ln -fs mkfs.fat $(TARGET_DIR)/sbin/mkdosfs
	ln -fs mkfs.fat $(TARGET_DIR)/sbin/mkfs.msdos
	ln -fs mkfs.fat $(TARGET_DIR)/sbin/mkfs.vfat
endef
endif

define DOSFSTOOLS_INSTALL_TARGET_CMDS
	$(DOSFSTOOLS_INSTALL_FATLABEL)
	$(DOSFSTOOLS_INSTALL_FSCK_FAT)
	$(DOSFSTOOLS_INSTALL_MKFS_FAT)
endef

define HOST_DOSFSTOOLS_BUILD_CMDS
	$(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D)
endef

define HOST_DOSFSTOOLS_INSTALL_CMDS
	$(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) PREFIX=$(HOST_DIR)/usr install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
