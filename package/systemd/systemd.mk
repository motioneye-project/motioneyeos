################################################################################
#
# systemd
#
################################################################################

SYSTEMD_VERSION = 215
SYSTEMD_SITE = http://www.freedesktop.org/software/systemd
SYSTEMD_SOURCE = systemd-$(SYSTEMD_VERSION).tar.xz
SYSTEMD_LICENSE = LGPLv2.1+; GPLv2+ for udev; MIT-like license for few source files listed in README
SYSTEMD_LICENSE_FILES = LICENSE.GPL2 LICENSE.LGPL2.1 LICENSE.MIT
SYSTEMD_INSTALL_STAGING = YES
SYSTEMD_DEPENDENCIES = \
	host-intltool \
	libcap \
	util-linux \
	kmod \
	host-gperf

SYSTEMD_PROVIDES = udev
SYSTEMD_AUTORECONF = YES

# Make sure that systemd will always be built after busybox so that we have
# a consistent init setup between two builds
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
SYSTEMD_DEPENDENCIES += busybox
endif

SYSTEMD_CONF_OPT += \
	--with-rootprefix= \
	--with-rootlibdir=/lib \
	--localstatedir=/var \
	--enable-static=no \
	--disable-manpages \
	--disable-selinux \
	--disable-pam \
	--disable-libcryptsetup \
	--disable-gtk-doc \
	--with-dbuspolicydir=/etc/dbus-1/system.d \
	--with-dbussessionservicedir=/usr/share/dbus-1/services \
	--with-dbussystemservicedir=/usr/share/dbus-1/system-services \
	--with-dbusinterfacedir=/usr/share/dbus-1/interfaces \
	--with-firmware-path=/lib/firmware \
	--enable-split-usr \
	--enable-introspection=no \
	--disable-efi \
	--disable-tcpwrap \
	--disable-tests \
	--disable-dbus \
	--without-python

# Override path to kmod, used in kmod-static-nodes.service
SYSTEMD_CONF_ENV = \
	ac_cv_path_KMOD=/usr/bin/kmod

ifeq ($(BR2_PACKAGE_SYSTEMD_COMPAT),y)
SYSTEMD_CONF_OPT += --enable-compat-libs
else
SYSTEMD_CONF_OPT += --disable-compat-libs
endif

ifeq ($(BR2_PACKAGE_ACL),y)
SYSTEMD_CONF_OPT += --enable-acl
SYSTEMD_DEPENDENCIES += acl
else
SYSTEMD_CONF_OPT += --disable-acl
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
SYSTEMD_CONF_OPT += --enable-gudev
SYSTEMD_DEPENDENCIES += libglib2
else
SYSTEMD_CONF_OPT += --disable-gudev
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_ALL_EXTRAS),y)
SYSTEMD_DEPENDENCIES += \
	xz 		\
	libgcrypt
SYSTEMD_CONF_OPT += 	\
	--enable-xz 	\
	--enable-gcrypt	\
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
SYSTEMD_CONF_OPT += 	\
	--disable-xz 	\
	--disable-gcrypt
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_JOURNAL_GATEWAY),y)
SYSTEMD_DEPENDENCIES += libmicrohttpd
else
SYSTEMD_CONF_OPT += --disable-microhttpd
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_NETWORKD),y)
SYSTEMD_CONF_OPT += --enable-networkd
define SYSTEMD_INSTALL_RESOLVCONF_HOOK
	ln -sf ../run/systemd/resolve/resolv.conf \
		$(TARGET_DIR)/etc/resolv.conf
endef
else
SYSTEMD_CONF_OPT += --disable-networkd
define SYSTEMD_INSTALL_SERVICE_NETWORK
	$(INSTALL) -D -m 644 package/systemd/network.service \
		$(TARGET_DIR)/etc/systemd/system/network.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../network.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/network.service
endef
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TIMESYNCD),y)
SYSTEMD_CONF_OPT += --enable-timesyncd
define SYSTEMD_INSTALL_SERVICE_TIMESYNC
	mkdir -p $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -sf ../../../../lib/systemd/system/systemd-timesyncd.service \
		$(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service
endef
else
SYSTEMD_CONF_OPT += --disable-timesyncd
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SMACK_SUPPORT),y)
SYSTEMD_CONF_OPT += --enable-smack
else
SYSTEMD_CONF_OPT += --disable-smack
endif

# mq_getattr needs -lrt
SYSTEMD_MAKE_OPT += LIBS=-lrt
SYSTEMD_MAKE_OPT += LDFLAGS+=-ldl

define SYSTEMD_INSTALL_INIT_HOOK
	ln -fs ../lib/systemd/systemd $(TARGET_DIR)/sbin/init
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/halt
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/poweroff
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/reboot

	ln -fs ../../../lib/systemd/system/multi-user.target $(TARGET_DIR)/etc/systemd/system/default.target
endef

define SYSTEMD_INSTALL_MACHINEID_HOOK
	touch $(TARGET_DIR)/etc/machine-id
endef

define SYSTEMD_SANITIZE_PATH_IN_UNITS
	find $(TARGET_DIR)/lib/systemd/system -name '*.service' \
		-exec $(SED) 's,$(HOST_DIR),,g' {} \;
endef

# Disable ldconfig.service, as /sbin/ldconfig is not available when the
# target is built with a glibc-based toolchain.
define SYSTEMD_DISABLE_LDCONFIG_SERVICE_HOOK
	rm -f $(TARGET_DIR)/lib/systemd/system/sysinit.target.wants/ldconfig.service
endef

SYSTEMD_POST_INSTALL_TARGET_HOOKS += \
	SYSTEMD_INSTALL_INIT_HOOK \
	SYSTEMD_INSTALL_MACHINEID_HOOK \
	SYSTEMD_INSTALL_RESOLVCONF_HOOK \
	SYSTEMD_DISABLE_LDCONFIG_SERVICE_HOOK \
	SYSTEMD_SANITIZE_PATH_IN_UNITS

define SYSTEMD_USERS
	systemd-journal -1 systemd-journal -1 * /var/log/journal - - Journal
	systemd-journal-gateway -1 systemd-journal-gateway -1 * /var/log/journal - - Journal Gateway
	systemd-resolve -1 systemd-resolve -1 * - - - Network Name Resolution Manager
	systemd-bus-proxy -1 systemd-bus-proxy -1 * - - - Proxy D-Bus messages to/from a bus
	systemd-timesync -1 systemd-timesync -1 * - - - Network Time Synchronization
	systemd-network -1 systemd-network -1 * - - - Network Manager
endef

define SYSTEMD_INSTALL_SERVICE_TTY
	rm -f $(TARGET_DIR)/etc/systemd/system/getty.target.wants/getty@tty1.service
	ln -fs ../../../../lib/systemd/system/serial-getty@.service $(TARGET_DIR)/etc/systemd/system/getty.target.wants/serial-getty@$(BR2_TARGET_GENERIC_GETTY_PORT).service
endef

define SYSTEMD_INSTALL_INIT_SYSTEMD
	$(SYSTEMD_INSTALL_SERVICE_TTY)
	$(SYSTEMD_INSTALL_SERVICE_NETWORK)
	$(SYSTEMD_INSTALL_SERVICE_TIMESYNC)
endef

$(eval $(autotools-package))
