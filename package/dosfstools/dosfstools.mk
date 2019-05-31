################################################################################
#
# dosfstools
#
################################################################################

DOSFSTOOLS_VERSION = 4.1
DOSFSTOOLS_SOURCE = dosfstools-$(DOSFSTOOLS_VERSION).tar.xz
DOSFSTOOLS_SITE = https://github.com/dosfstools/dosfstools/releases/download/v$(DOSFSTOOLS_VERSION)
DOSFSTOOLS_LICENSE = GPL-3.0+
DOSFSTOOLS_LICENSE_FILES = COPYING
DOSFSTOOLS_CONF_OPTS = --enable-compat-symlinks --exec-prefix=/
HOST_DOSFSTOOLS_CONF_OPTS = --enable-compat-symlinks

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
DOSFSTOOLS_CONF_OPTS += --with-udev
DOSFSTOOLS_DEPENDENCIES += udev
else
DOSFSTOOLS_CONF_OPTS += --without-udev
endif

ifneq ($(BR2_ENABLE_LOCALE),y)
DOSFSTOOLS_CONF_OPTS += LIBS="-liconv"
DOSFSTOOLS_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_FATLABEL),y)
define DOSFSTOOLS_INSTALL_FATLABEL
	$(INSTALL) -D -m 0755 $(@D)/src/fatlabel $(TARGET_DIR)/sbin/fatlabel
	ln -sf fatlabel $(TARGET_DIR)/sbin/dosfslabel
endef
endif

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_FSCK_FAT),y)
define DOSFSTOOLS_INSTALL_FSCK_FAT
	$(INSTALL) -D -m 0755 $(@D)/src/fsck.fat $(TARGET_DIR)/sbin/fsck.fat
	ln -sf fsck.fat $(TARGET_DIR)/sbin/fsck.vfat
	ln -sf fsck.fat $(TARGET_DIR)/sbin/fsck.msdos
	ln -sf fsck.fat $(TARGET_DIR)/sbin/dosfsck
endef
endif

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_MKFS_FAT),y)
define DOSFSTOOLS_INSTALL_MKFS_FAT
	$(INSTALL) -D -m 0755 $(@D)/src/mkfs.fat $(TARGET_DIR)/sbin/mkfs.fat
	ln -sf mkfs.fat $(TARGET_DIR)/sbin/mkdosfs
	ln -sf mkfs.fat $(TARGET_DIR)/sbin/mkfs.msdos
	ln -sf mkfs.fat $(TARGET_DIR)/sbin/mkfs.vfat
endef
endif

define DOSFSTOOLS_INSTALL_TARGET_CMDS
	$(call DOSFSTOOLS_INSTALL_FATLABEL)
	$(call DOSFSTOOLS_INSTALL_FSCK_FAT)
	$(call DOSFSTOOLS_INSTALL_MKFS_FAT)
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
