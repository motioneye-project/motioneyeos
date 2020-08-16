################################################################################
#
# udev-gentoo-scripts
#
################################################################################

UDEV_GENTOO_SCRIPTS_VERSION = 33
UDEV_GENTOO_SCRIPTS_SOURCE = udev-gentoo-scripts-$(UDEV_GENTOO_SCRIPTS_VERSION).tar.bz2
UDEV_GENTOO_SCRIPTS_SITE = https://gitweb.gentoo.org/proj/udev-gentoo-scripts.git/snapshot
UDEV_GENTOO_SCRIPTS_LICENSE = GPL-2.0
UDEV_GENTOO_SCRIPTS_LICENSE_FILES = init.d/udev-settle

# We don't need to symlink /etc/init.d/udev to /etc/runlevels/sysinit, since
# it's in the udev-settle and udev-trigger "need" lists.
define UDEV_GENTOO_SCRIPTS_INSTALL_INIT_OPENRC
	$(MAKE1) -C $(@D) install DESTDIR=$(TARGET_DIR)
	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/runlevels/sysinit
	ln -s -f /etc/init.d/udev-settle /etc/init.d/udev-trigger \
		$(TARGET_DIR)/etc/runlevels/sysinit
endef

$(eval $(generic-package))
