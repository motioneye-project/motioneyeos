################################################################################
#
# systemd
#
################################################################################

SYSTEMD_VERSION = 234
SYSTEMD_SITE = $(call github,systemd,systemd,v$(SYSTEMD_VERSION))
SYSTEMD_LICENSE = LGPL-2.1+, GPL-2.0+ (udev), Public Domain (few source files, see README)
SYSTEMD_LICENSE_FILES = LICENSE.GPL2 LICENSE.LGPL2.1 README
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

SYSTEMD_CONF_OPTS += \
	--with-rootprefix= \
	--enable-blkid \
	--enable-static=no \
	--disable-manpages \
	--disable-ima \
	--disable-libcryptsetup \
	--disable-efi \
	--disable-gnuefi \
	--disable-ldconfig \
	--disable-tests \
	--disable-coverage \
	--with-default-dnssec=no \
	--without-python

SYSTEMD_CFLAGS = $(TARGET_CFLAGS) -fno-lto

# Override paths to a few utilities needed at runtime, to
# avoid finding those we would install in $(HOST_DIR).
SYSTEMD_CONF_ENV = \
	CFLAGS="$(SYSTEMD_CFLAGS)" \
	ac_cv_path_KILL=/usr/bin/kill \
	ac_cv_path_KMOD=/usr/bin/kmod \
	ac_cv_path_KEXEC=/usr/sbin/kexec \
	ac_cv_path_SULOGIN=/usr/sbin/sulogin \
	ac_cv_path_MOUNT_PATH=/usr/bin/mount \
	ac_cv_path_UMOUNT_PATH=/usr/bin/umount

define SYSTEMD_RUN_INTLTOOLIZE
	cd $(@D) && $(HOST_DIR)/bin/intltoolize --force --automake
endef
SYSTEMD_PRE_CONFIGURE_HOOKS += SYSTEMD_RUN_INTLTOOLIZE

ifeq ($(BR2_PACKAGE_ACL),y)
SYSTEMD_CONF_OPTS += --enable-acl
SYSTEMD_DEPENDENCIES += acl
else
SYSTEMD_CONF_OPTS += --disable-acl
endif

ifeq ($(BR2_PACKAGE_AUDIT),y)
SYSTEMD_CONF_OPTS += --enable-audit
SYSTEMD_DEPENDENCIES += audit
else
SYSTEMD_CONF_OPTS += --disable-audit
endif

ifeq ($(BR2_PACKAGE_LIBIDN),y)
SYSTEMD_CONF_OPTS += --enable-libidn
SYSTEMD_DEPENDENCIES += libidn
else
SYSTEMD_CONF_OPTS += --disable-libidn
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
SYSTEMD_CONF_OPTS += --enable-seccomp
SYSTEMD_DEPENDENCIES += libseccomp
else
SYSTEMD_CONF_OPTS += --disable-seccomp
endif

ifeq ($(BR2_PACKAGE_LIBXKBCOMMON),y)
SYSTEMD_CONF_OPTS += --enable-xkbcommon
SYSTEMD_DEPENDENCIES += libxkbcommon
else
SYSTEMD_CONF_OPTS += --disable-xkbcommon
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
SYSTEMD_DEPENDENCIES += bzip2
SYSTEMD_CONF_OPTS += --enable-bzip2
else
SYSTEMD_CONF_OPTS += --disable-bzip2
endif

ifeq ($(BR2_PACKAGE_LZ4),y)
SYSTEMD_DEPENDENCIES += lz4
SYSTEMD_CONF_OPTS += --enable-lz4
else
SYSTEMD_CONF_OPTS += --disable-lz4
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
SYSTEMD_DEPENDENCIES += linux-pam
SYSTEMD_CONF_OPTS += --enable-pam
else
SYSTEMD_CONF_OPTS += --disable-pam
endif

ifeq ($(BR2_PACKAGE_XZ),y)
SYSTEMD_DEPENDENCIES += xz
SYSTEMD_CONF_OPTS += --enable-xz
else
SYSTEMD_CONF_OPTS += --disable-xz
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
SYSTEMD_DEPENDENCIES += zlib
SYSTEMD_CONF_OPTS += --enable-zlib
else
SYSTEMD_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
SYSTEMD_DEPENDENCIES += libcurl
SYSTEMD_CONF_OPTS += --enable-libcurl
else
SYSTEMD_CONF_OPTS += --disable-libcurl
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
SYSTEMD_DEPENDENCIES += libgcrypt
SYSTEMD_CONF_OPTS += \
	--enable-gcrypt \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr \
	--with-libgpg-error-prefix=$(STAGING_DIR)/usr
else
SYSTEMD_CONF_OPTS += --disable-gcrypt
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_JOURNAL_GATEWAY),y)
SYSTEMD_DEPENDENCIES += libmicrohttpd
SYSTEMD_CONF_OPTS += --enable-microhttpd
ifeq ($(BR2_PACKAGE_LIBQRENCODE),y)
SYSTEMD_CONF_OPTS += --enable-qrencode
SYSTEMD_DEPENDENCIES += libqrencode
else
SYSTEMD_CONF_OPTS += --disable-qrencode
endif
else
SYSTEMD_CONF_OPTS += --disable-microhttpd --disable-qrencode
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
SYSTEMD_DEPENDENCIES += libselinux
SYSTEMD_CONF_OPTS += --enable-selinux
else
SYSTEMD_CONF_OPTS += --disable-selinux
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HWDB),y)
SYSTEMD_CONF_OPTS += --enable-hwdb
else
SYSTEMD_CONF_OPTS += --disable-hwdb
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_BINFMT),y)
SYSTEMD_CONF_OPTS += --enable-binfmt
else
SYSTEMD_CONF_OPTS += --disable-binfmt
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_VCONSOLE),y)
SYSTEMD_CONF_OPTS += --enable-vconsole
else
SYSTEMD_CONF_OPTS += --disable-vconsole
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_QUOTACHECK),y)
SYSTEMD_CONF_OPTS += --enable-quotacheck
SYSTEMD_CONF_ENV += \
	ac_cv_path_QUOTAON=/usr/sbin/quotaon \
	ac_cv_path_QUOTACHECK=/usr/sbin/quotacheck
else
SYSTEMD_CONF_OPTS += --disable-quotacheck
SYSTEMD_CONF_ENV += \
	ac_cv_path_QUOTAON=/.missing \
	ac_cv_path_QUOTACHECK=/.missing
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TMPFILES),y)
SYSTEMD_CONF_OPTS += --enable-tmpfiles
else
SYSTEMD_CONF_OPTS += --disable-tmpfiles
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SYSUSERS),y)
SYSTEMD_CONF_OPTS += --enable-sysusers
else
SYSTEMD_CONF_OPTS += --disable-sysusers
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_FIRSTBOOT),y)
SYSTEMD_CONF_OPTS += --enable-firstboot
else
SYSTEMD_CONF_OPTS += --disable-firstboot
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RANDOMSEED),y)
SYSTEMD_CONF_OPTS += --enable-randomseed
else
SYSTEMD_CONF_OPTS += --disable-randomseed
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_BACKLIGHT),y)
SYSTEMD_CONF_OPTS += --enable-backlight
else
SYSTEMD_CONF_OPTS += --disable-backlight
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RFKILL),y)
SYSTEMD_CONF_OPTS += --enable-rfkill
else
SYSTEMD_CONF_OPTS += --disable-rfkill
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_LOGIND),y)
SYSTEMD_CONF_OPTS += --enable-logind
else
SYSTEMD_CONF_OPTS += --disable-logind
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_MACHINED),y)
SYSTEMD_CONF_OPTS += --enable-machined
else
SYSTEMD_CONF_OPTS += --disable-machined
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_IMPORTD),y)
SYSTEMD_CONF_OPTS += --enable-importd
else
SYSTEMD_CONF_OPTS += --disable-importd
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HOSTNAMED),y)
SYSTEMD_CONF_OPTS += --enable-hostnamed
else
SYSTEMD_CONF_OPTS += --disable-hostnamed
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_MYHOSTNAME),y)
SYSTEMD_CONF_OPTS += --enable-myhostname
else
SYSTEMD_CONF_OPTS += --disable-myhostname
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TIMEDATED),y)
SYSTEMD_CONF_OPTS += --enable-timedated
else
SYSTEMD_CONF_OPTS += --disable-timedated
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_LOCALED),y)
SYSTEMD_CONF_OPTS += --enable-localed
else
SYSTEMD_CONF_OPTS += --disable-localed
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_COREDUMP),y)
SYSTEMD_CONF_OPTS += --enable-coredump
SYSTEMD_COREDUMP_USER = systemd-coredump -1 systemd-coredump -1 * /var/lib/systemd/coredump - - Core Dumper
else
SYSTEMD_CONF_OPTS += --disable-coredump
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_POLKIT),y)
SYSTEMD_CONF_OPTS += --enable-polkit
else
SYSTEMD_CONF_OPTS += --disable-polkit
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_NETWORKD),y)
SYSTEMD_CONF_OPTS += --enable-networkd
SYSTEMD_NETWORKD_USER = systemd-network -1 systemd-network -1 * - - - Network Manager
define SYSTEMD_INSTALL_RESOLVCONF_HOOK
	ln -sf ../run/systemd/resolve/resolv.conf \
		$(TARGET_DIR)/etc/resolv.conf
endef
SYSTEMD_NETWORKD_DHCP_IFACE = $(call qstrip,$(BR2_SYSTEM_DHCP))
ifneq ($(SYSTEMD_NETWORKD_DHCP_IFACE),)
define SYSTEMD_INSTALL_NETWORK_CONFS
	sed s/SYSTEMD_NETWORKD_DHCP_IFACE/$(SYSTEMD_NETWORKD_DHCP_IFACE)/ \
		package/systemd/dhcp.network > \
		$(TARGET_DIR)/etc/systemd/network/dhcp.network
endef
endif
else
SYSTEMD_CONF_OPTS += --disable-networkd
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RESOLVED),y)
SYSTEMD_CONF_OPTS += --enable-resolved
SYSTEMD_RESOLVED_USER = systemd-resolve -1 systemd-resolve -1 * - - - Network Name Resolution Manager
else
SYSTEMD_CONF_OPTS += --disable-resolved
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TIMESYNCD),y)
SYSTEMD_CONF_OPTS += --enable-timesyncd
SYSTEMD_TIMESYNCD_USER = systemd-timesync -1 systemd-timesync -1 * - - - Network Time Synchronization
define SYSTEMD_INSTALL_SERVICE_TIMESYNC
	mkdir -p $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -sf ../../../../lib/systemd/system/systemd-timesyncd.service \
		$(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service
endef
else
SYSTEMD_CONF_OPTS += --disable-timesyncd
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SMACK_SUPPORT),y)
SYSTEMD_CONF_OPTS += --enable-smack
else
SYSTEMD_CONF_OPTS += --disable-smack
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HIBERNATE),y)
SYSTEMD_CONF_OPTS += --enable-hibernate
else
SYSTEMD_CONF_OPTS += --disable-hibernate
endif

define SYSTEMD_INSTALL_INIT_HOOK
	ln -fs ../lib/systemd/systemd $(TARGET_DIR)/sbin/init
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/halt
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/poweroff
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/reboot

	ln -fs ../../../lib/systemd/system/multi-user.target \
		$(TARGET_DIR)/etc/systemd/system/default.target
endef

define SYSTEMD_INSTALL_MACHINEID_HOOK
	touch $(TARGET_DIR)/etc/machine-id
endef

SYSTEMD_POST_INSTALL_TARGET_HOOKS += \
	SYSTEMD_INSTALL_INIT_HOOK \
	SYSTEMD_INSTALL_MACHINEID_HOOK \
	SYSTEMD_INSTALL_RESOLVCONF_HOOK

define SYSTEMD_USERS
	- - input -1 * - - - Input device group
	- - systemd-journal -1 * - - - Journal
	systemd-bus-proxy -1 systemd-bus-proxy -1 * - - - Proxy D-Bus messages to/from a bus
	systemd-journal-gateway -1 systemd-journal-gateway -1 * /var/log/journal - - Journal Gateway
	systemd-journal-remote -1 systemd-journal-remote -1 * /var/log/journal/remote - - Journal Remote
	systemd-journal-upload -1 systemd-journal-upload -1 * - - - Journal Upload
	$(SYSTEMD_COREDUMP_USER)
	$(SYSTEMD_NETWORKD_USER)
	$(SYSTEMD_RESOLVED_USER)
	$(SYSTEMD_TIMESYNCD_USER)
endef

define SYSTEMD_DISABLE_SERVICE_TTY1
	rm -f $(TARGET_DIR)/etc/systemd/system/getty.target.wants/getty@tty1.service
endef

ifneq ($(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)),)
# systemd needs getty.service for VTs and serial-getty.service for serial ttys
# also patch the file to use the correct baud-rate, the default baudrate is 115200 so look for that
define SYSTEMD_INSTALL_SERVICE_TTY
	if echo $(BR2_TARGET_GENERIC_GETTY_PORT) | egrep -q 'tty[0-9]*$$'; \
	then \
		SERVICE="getty"; \
	else \
		SERVICE="serial-getty"; \
	fi; \
	ln -fs ../../../../lib/systemd/system/$${SERVICE}@.service \
		$(TARGET_DIR)/etc/systemd/system/getty.target.wants/$${SERVICE}@$(BR2_TARGET_GENERIC_GETTY_PORT).service; \
	if [ $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE)) -gt 0 ] ; \
	then \
		$(SED) 's,115200,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),' $(TARGET_DIR)/lib/systemd/system/$${SERVICE}@.service; \
	fi
endef
endif

define SYSTEMD_INSTALL_INIT_SYSTEMD
	$(SYSTEMD_DISABLE_SERVICE_TTY1)
	$(SYSTEMD_INSTALL_SERVICE_TTY)
	$(SYSTEMD_INSTALL_SERVICE_TIMESYNC)
	$(SYSTEMD_INSTALL_NETWORK_CONFS)
endef

$(eval $(autotools-package))
