################################################################################
#
# avrdude
#
################################################################################

AVRDUDE_VERSION = ad04c429a90f4c34f000ea4ae11db2705915a31f
AVRDUDE_SITE = $(call github,kcuzner,avrdude,$(AVRDUDE_VERSION))
AVRDUDE_LICENSE = GPL-2.0+
AVRDUDE_LICENSE_FILES = avrdude/COPYING
AVRDUDE_SUBDIR = avrdude
# Sources coming from git, without generated configure and Makefile.in
# files.
AVRDUDE_AUTORECONF = YES
AVRDUDE_DEPENDENCIES = elfutils libusb libusb-compat ncurses \
	host-flex host-bison
AVRDUDE_LICENSE = GPL-2.0+
AVRDUDE_LICENSE_FILES = avrdude/COPYING

ifeq ($(BR2_PACKAGE_LIBFTDI1),y)
AVRDUDE_DEPENDENCIES += libftdi1
else ifeq ($(BR2_PACKAGE_LIBFTDI),y)
AVRDUDE_DEPENDENCIES += libftdi
endif

# if /etc/avrdude.conf exists, the installation process creates a
# backup file, which we do not want in the context of Buildroot.
define AVRDUDE_REMOVE_BACKUP_FILE
	$(RM) -f $(TARGET_DIR)/etc/avrdude.conf.bak
endef

AVRDUDE_POST_INSTALL_TARGET_HOOKS += AVRDUDE_REMOVE_BACKUP_FILE

$(eval $(autotools-package))
