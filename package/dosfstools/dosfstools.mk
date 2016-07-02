################################################################################
#
# dosfstools
#
################################################################################

DOSFSTOOLS_VERSION = 4.0
DOSFSTOOLS_SOURCE = dosfstools-$(DOSFSTOOLS_VERSION).tar.xz
DOSFSTOOLS_SITE = https://github.com/dosfstools/dosfstools/releases/download/v$(DOSFSTOOLS_VERSION)
DOSFSTOOLS_LICENSE = GPLv3+
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

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_FATLABEL),)
define DOSFSTOOLS_REMOVE_FATLABEL
	rm -f $(addprefix $(TARGET_DIR)/sbin/,dosfslabel fatlabel)
endef
DOSFSTOOLS_POST_INSTALL_TARGET_HOOKS += DOSFSTOOLS_REMOVE_FATLABEL
endif

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_FSCK_FAT),)
define DOSFSTOOLS_REMOVE_FSCK_FAT
	rm -f $(addprefix $(TARGET_DIR)/sbin/,fsck.fat dosfsck fsck.msdos fsck.vfat)
endef
DOSFSTOOLS_POST_INSTALL_TARGET_HOOKS += DOSFSTOOLS_REMOVE_FSCK_FAT
endif

ifeq ($(BR2_PACKAGE_DOSFSTOOLS_MKFS_FAT),)
define DOSFSTOOLS_REMOVE_MKFS_FAT
	rm -f $(addprefix $(TARGET_DIR)/sbin/,mkfs.fat mkdosfs mkfs.msdos mkfs.vfat)
endef
DOSFSTOOLS_POST_INSTALL_TARGET_HOOKS += DOSFSTOOLS_REMOVE_MKFS_FAT
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
