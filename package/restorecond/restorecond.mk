################################################################################
#
# restorecond
#
################################################################################

RESTORECOND_VERSION = 2.8
RESTORECOND_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20180524
RESTORECOND_LICENSE = GPL-2.0
RESTORECOND_LICENSE_FILES = COPYING

RESTORECOND_DEPENDENCIES = libglib2 libsepol libselinux dbus-glib

# Undefining _FILE_OFFSET_BITS here because of a "bug" with glibc fts.h
# large file support.
# See https://bugzilla.redhat.com/show_bug.cgi?id=574992 for more information
RESTORECOND_MAKE_OPTS += \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) -U_FILE_OFFSET_BITS" \
	CPPFLAGS="$(TARGET_CPPFLAGS) -U_FILE_OFFSET_BITS" \
	ARCH="$(BR2_ARCH)"

# We need to pass DESTDIR at build time because it's used by
# restorecond build system to find headers and libraries.
define RESTORECOND_BUILD_CMDS
	$(MAKE) -C $(@D) $(RESTORECOND_MAKE_OPTS) DESTDIR=$(STAGING_DIR) all
endef

define RESTORECOND_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(@D)/restorecond.init \
		$(TARGET_DIR)/etc/init.d/S20restorecond
endef

define RESTORECOND_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 0644 -D $(@D)/restorecond.service \
		$(TARGET_DIR)/usr/lib/systemd/system/restorecond.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/restorecond.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/restorecond.service

	$(INSTALL) -m 0600 -D $(@D)/org.selinux.Restorecond.service \
		$(TARGET_DIR)/etc/systemd/system/org.selinux.Restorecond.service
endef

define RESTORECOND_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/restorecond.conf $(TARGET_DIR)/etc/selinux/restorecond.conf
	$(INSTALL) -m 0644 -D $(@D)/restorecond_user.conf $(TARGET_DIR)/etc/selinux/restorecond_user.conf
	$(INSTALL) -m 0755 -D $(@D)/restorecond $(TARGET_DIR)/usr/sbin/restorecond
endef

$(eval $(generic-package))
