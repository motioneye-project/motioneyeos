################################################################################
#
# systemd
#
################################################################################

SYSTEMD_VERSION = 44
SYSTEMD_SITE = http://www.freedesktop.org/software/systemd/
SYSTEMD_SOURCE = systemd-$(SYSTEMD_VERSION).tar.xz
SYSTEMD_LICENSE = GPLv2+
SYSTEMD_LICENSE_FILES = LICENSE
SYSTEMD_INSTALL_STAGING = YES
SYSTEMD_DEPENDENCIES = \
	host-intltool \
	libcap \
	udev \
	dbus

# Make sure that systemd will always be built after busybox so that we have
# a consistent init setup between two builds
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	SYSTEMD_DEPENDENCIES += busybox
endif

SYSTEMD_AUTORECONF = YES

SYSTEMD_CONF_OPT += \
	--with-distro=other \
	--disable-selinux \
	--disable-pam \
	--disable-libcryptsetup \
	--disable-gtk \
	--disable-plymouth \
	--with-rootdir=/ \
	--with-dbuspolicydir=/etc/dbus-1/system.d \
	--with-dbussessionservicedir=/usr/share/dbus-1/services \
	--with-dbussystemservicedir=/usr/share/dbus-1/system-services \
	--with-dbusinterfacedir=/usr/share/dbus-1/interfaces \
	--with-udevrulesdir=/etc/udev/rules.d \
	--with-sysvinit-path=/etc/init.d/ \
	--without-sysvrcd-path \
	--enable-split-usr

ifeq ($(BR2_PACKAGE_ACL),y)
	SYSTEMD_CONF_OPT += --enable-acl
	SYSTEMD_DEPENDENCIES += acl
else
	SYSTEMD_CONF_OPT += --disable-acl
endif

ifneq ($(BR2_LARGEFILE),y)
	SYSTEMD_CONF_OPT += --disable-largefile
endif

# mq_getattr needs -lrt
SYSTEMD_MAKE_OPT += LIBS=-lrt
SYSTEMD_MAKE_OPT += LDFLAGS+=-ldl

ifeq ($(BR2_INIT_SYSTEMD),y)
define SYSTEMD_INSTALL_INIT_HOOK
	ln -fs ../usr/lib/systemd/systemd $(TARGET_DIR)/sbin/init
	ln -fs ../usr/bin/systemctl $(TARGET_DIR)/sbin/halt
	ln -fs ../usr/bin/systemctl $(TARGET_DIR)/sbin/poweroff
	ln -fs ../usr/bin/systemctl $(TARGET_DIR)/sbin/reboot

	ln -fs ../../../usr/lib/systemd/system/multi-user.target $(TARGET_DIR)/etc/systemd/system/default.target
endef
SYSTEMD_POST_INSTALL_TARGET_HOOKS += \
	SYSTEMD_INSTALL_INIT_HOOK
endif

define SYSTEMD_INSTALL_TTY_HOOK
	rm -f $(TARGET_DIR)/etc/systemd/system/getty.target.wants/getty@tty1.service
	ln -fs ../../../../usr/lib/systemd/system/serial-getty@.service $(TARGET_DIR)/etc/systemd/system/getty.target.wants/serial-getty@$(BR2_TARGET_GENERIC_GETTY_PORT).service
endef

SYSTEMD_POST_INSTALL_TARGET_HOOKS += \
	SYSTEMD_INSTALL_TTY_HOOK \

$(eval $(autotools-package))
