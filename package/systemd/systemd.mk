################################################################################
#
# systemd
#
################################################################################

SYSTEMD_VERSION = 240
SYSTEMD_SITE = $(call github,systemd,systemd,v$(SYSTEMD_VERSION))
SYSTEMD_LICENSE = LGPL-2.1+, GPL-2.0+ (udev), Public Domain (few source files, see README)
SYSTEMD_LICENSE_FILES = LICENSE.GPL2 LICENSE.LGPL2.1 README
SYSTEMD_INSTALL_STAGING = YES
SYSTEMD_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_BASH_COMPLETION),bash-completion) \
	host-gperf \
	host-intltool \
	kmod \
	libcap \
	util-linux

SYSTEMD_PROVIDES = udev

SYSTEMD_CONF_OPTS += \
	-Drootlibdir='/usr/lib' \
	-Dblkid=true \
	-Dman=false \
	-Dima=false \
	-Defi=false \
	-Dgnu-efi=false \
	-Dldconfig=false \
	-Ddefault-dnssec=no \
	-Dtests=false \
	-Dsplit-bin=true \
	-Dsplit-usr=false \
	-Dsystem-uid-max=999 \
	-Dsystem-gid-max=999 \
	-Dtelinit-path=$(TARGET_DIR)/sbin/telinit \
	-Dkmod-path=/usr/bin/kmod \
	-Dkexec-path=/usr/sbin/kexec \
	-Dsulogin-path=/usr/sbin/sulogin \
	-Dmount-path=/usr/bin/mount \
	-Dumount-path=/usr/bin/umount \
	-Dnobody-group=nogroup \
	-Didn=true \
	-Dnss-systemd=true

ifeq ($(BR2_PACKAGE_ACL),y)
SYSTEMD_DEPENDENCIES += acl
SYSTEMD_CONF_OPTS += -Dacl=true
else
SYSTEMD_CONF_OPTS += -Dacl=false
endif

ifeq ($(BR2_PACKAGE_AUDIT),y)
SYSTEMD_DEPENDENCIES += audit
SYSTEMD_CONF_OPTS += -Daudit=true
else
SYSTEMD_CONF_OPTS += -Daudit=false
endif

ifeq ($(BR2_PACKAGE_CRYPTSETUP),y)
SYSTEMD_DEPENDENCIES += cryptsetup
SYSTEMD_CONF_OPTS += -Dlibcryptsetup=true
else
SYSTEMD_CONF_OPTS += -Dlibcryptsetup=false
endif

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
SYSTEMD_DEPENDENCIES += elfutils
SYSTEMD_CONF_OPTS += -Delfutils=true
else
SYSTEMD_CONF_OPTS += -Delfutils=false
endif

ifeq ($(BR2_PACKAGE_IPTABLES),y)
SYSTEMD_DEPENDENCIES += iptables
SYSTEMD_CONF_OPTS += -Dlibiptc=true
else
SYSTEMD_CONF_OPTS += -Dlibiptc=false
endif

# Both options can't be selected at the same time so prefer libidn2
ifeq ($(BR2_PACKAGE_LIBIDN2),y)
SYSTEMD_DEPENDENCIES += libidn2
SYSTEMD_CONF_OPTS += -Dlibidn2=true -Dlibidn=false
else ifeq ($(BR2_PACKAGE_LIBIDN),y)
SYSTEMD_DEPENDENCIES += libidn
SYSTEMD_CONF_OPTS += -Dlibidn=true -Dlibidn2=false
else
SYSTEMD_CONF_OPTS += -Dlibidn=false -Dlibidn2=false
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
SYSTEMD_DEPENDENCIES += libseccomp
SYSTEMD_CONF_OPTS += -Dseccomp=true
else
SYSTEMD_CONF_OPTS += -Dseccomp=false
endif

ifeq ($(BR2_PACKAGE_LIBXKBCOMMON),y)
SYSTEMD_DEPENDENCIES += libxkbcommon
SYSTEMD_CONF_OPTS += -Dxkbcommon=true
else
SYSTEMD_CONF_OPTS += -Dxkbcommon=false
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
SYSTEMD_DEPENDENCIES += bzip2
SYSTEMD_CONF_OPTS += -Dbzip2=true
else
SYSTEMD_CONF_OPTS += -Dbzip2=false
endif

ifeq ($(BR2_PACKAGE_LZ4),y)
SYSTEMD_DEPENDENCIES += lz4
SYSTEMD_CONF_OPTS += -Dlz4=true
else
SYSTEMD_CONF_OPTS += -Dlz4=false
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
SYSTEMD_DEPENDENCIES += linux-pam
SYSTEMD_CONF_OPTS += -Dpam=true
else
SYSTEMD_CONF_OPTS += -Dpam=false
endif

ifeq ($(BR2_PACKAGE_VALGRIND),y)
SYSTEMD_DEPENDENCIES += valgrind
SYSTEMD_CONF_OPTS += -Dvalgrind=true
else
SYSTEMD_CONF_OPTS += -Dvalgrind=false
endif

ifeq ($(BR2_PACKAGE_XZ),y)
SYSTEMD_DEPENDENCIES += xz
SYSTEMD_CONF_OPTS += -Dxz=true
else
SYSTEMD_CONF_OPTS += -Dxz=false
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
SYSTEMD_DEPENDENCIES += zlib
SYSTEMD_CONF_OPTS += -Dzlib=true
else
SYSTEMD_CONF_OPTS += -Dzlib=false
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
SYSTEMD_DEPENDENCIES += libcurl
SYSTEMD_CONF_OPTS += -Dlibcurl=true
else
SYSTEMD_CONF_OPTS += -Dlibcurl=false
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
SYSTEMD_DEPENDENCIES += libgcrypt
SYSTEMD_CONF_OPTS += -Dgcrypt=true
else
SYSTEMD_CONF_OPTS += -Dgcrypt=false
endif

ifeq ($(BR2_PACKAGE_PCRE2),y)
SYSTEMD_DEPENDENCIES += pcre2
SYSTEMD_CONF_OPTS += -Dpcre2=true
else
SYSTEMD_CONF_OPTS += -Dpcre2=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_JOURNAL_GATEWAY),y)
SYSTEMD_DEPENDENCIES += libmicrohttpd
SYSTEMD_CONF_OPTS += -Dmicrohttpd=true
ifeq ($(BR2_PACKAGE_LIBQRENCODE),y)
SYSTEMD_CONF_OPTS += -Dqrencode=true
SYSTEMD_DEPENDENCIES += libqrencode
else
SYSTEMD_CONF_OPTS += -Dqrencode=false
endif
else
SYSTEMD_CONF_OPTS += -Dmicrohttpd=false -Dqrencode=false
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
SYSTEMD_DEPENDENCIES += libselinux
SYSTEMD_CONF_OPTS += -Dselinux=true
else
SYSTEMD_CONF_OPTS += -Dselinux=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HWDB),y)
SYSTEMD_CONF_OPTS += -Dhwdb=true
else
SYSTEMD_CONF_OPTS += -Dhwdb=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_BINFMT),y)
SYSTEMD_CONF_OPTS += -Dbinfmt=true
else
SYSTEMD_CONF_OPTS += -Dbinfmt=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_VCONSOLE),y)
SYSTEMD_CONF_OPTS += -Dvconsole=true
else
SYSTEMD_CONF_OPTS += -Dvconsole=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_QUOTACHECK),y)
SYSTEMD_CONF_OPTS += -Dquotacheck=true
else
SYSTEMD_CONF_OPTS += -Dquotacheck=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TMPFILES),y)
SYSTEMD_CONF_OPTS += -Dtmpfiles=true
else
SYSTEMD_CONF_OPTS += -Dtmpfiles=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SYSUSERS),y)
SYSTEMD_CONF_OPTS += -Dsysusers=true
else
SYSTEMD_CONF_OPTS += -Dsysusers=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_FIRSTBOOT),y)
SYSTEMD_CONF_OPTS += -Dfirstboot=true
else
SYSTEMD_CONF_OPTS += -Dfirstboot=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RANDOMSEED),y)
SYSTEMD_CONF_OPTS += -Drandomseed=true
else
SYSTEMD_CONF_OPTS += -Drandomseed=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_BACKLIGHT),y)
SYSTEMD_CONF_OPTS += -Dbacklight=true
else
SYSTEMD_CONF_OPTS += -Dbacklight=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RFKILL),y)
SYSTEMD_CONF_OPTS += -Drfkill=true
else
SYSTEMD_CONF_OPTS += -Drfkill=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_LOGIND),y)
SYSTEMD_CONF_OPTS += -Dlogind=true
else
SYSTEMD_CONF_OPTS += -Dlogind=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_MACHINED),y)
SYSTEMD_CONF_OPTS += -Dmachined=true
else
SYSTEMD_CONF_OPTS += -Dmachined=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_IMPORTD),y)
SYSTEMD_CONF_OPTS += -Dimportd=true
else
SYSTEMD_CONF_OPTS += -Dimportd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HOSTNAMED),y)
SYSTEMD_CONF_OPTS += -Dhostnamed=true
else
SYSTEMD_CONF_OPTS += -Dhostnamed=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_MYHOSTNAME),y)
SYSTEMD_CONF_OPTS += -Dnss-myhostname=true
else
SYSTEMD_CONF_OPTS += -Dnss-myhostname=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TIMEDATED),y)
SYSTEMD_CONF_OPTS += -Dtimedated=true
else
SYSTEMD_CONF_OPTS += -Dtimedated=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_LOCALED),y)
SYSTEMD_CONF_OPTS += -Dlocaled=true
else
SYSTEMD_CONF_OPTS += -Dlocaled=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_COREDUMP),y)
SYSTEMD_CONF_OPTS += -Dcoredump=true
SYSTEMD_COREDUMP_USER = systemd-coredump -1 systemd-coredump -1 * /var/lib/systemd/coredump - - Core Dumper
else
SYSTEMD_CONF_OPTS += -Dcoredump=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_POLKIT),y)
SYSTEMD_CONF_OPTS += -Dpolkit=true
SYSTEMD_DEPENDENCIES += polkit
else
SYSTEMD_CONF_OPTS += -Dpolkit=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_NETWORKD),y)
SYSTEMD_CONF_OPTS += -Dnetworkd=true
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
SYSTEMD_CONF_OPTS += -Dnetworkd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RESOLVED),y)
SYSTEMD_CONF_OPTS += -Dresolve=true
SYSTEMD_RESOLVED_USER = systemd-resolve -1 systemd-resolve -1 * - - - Network Name Resolution Manager
else
SYSTEMD_CONF_OPTS += -Dresolve=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TIMESYNCD),y)
SYSTEMD_CONF_OPTS += -Dtimesyncd=true
SYSTEMD_TIMESYNCD_USER = systemd-timesync -1 systemd-timesync -1 * - - - Network Time Synchronization
define SYSTEMD_INSTALL_SERVICE_TIMESYNC
	mkdir -p $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -sf ../../../../lib/systemd/system/systemd-timesyncd.service \
		$(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service
endef
else
SYSTEMD_CONF_OPTS += -Dtimesyncd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SMACK_SUPPORT),y)
SYSTEMD_CONF_OPTS += -Dsmack=true
else
SYSTEMD_CONF_OPTS += -Dsmack=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HIBERNATE),y)
SYSTEMD_CONF_OPTS += -Dhibernate=true
else
SYSTEMD_CONF_OPTS += -Dhibernate=false
endif

SYSTEMD_FALLBACK_HOSTNAME = $(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))
ifneq ($(SYSTEMD_FALLBACK_HOSTNAME),)
SYSTEMD_CONF_OPTS += -Dfallback-hostname=$(SYSTEMD_FALLBACK_HOSTNAME)
endif

define SYSTEMD_INSTALL_INIT_HOOK
	ln -fs ../lib/systemd/systemd $(TARGET_DIR)/sbin/init
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/halt
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/poweroff
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/reboot
	ln -fs ../bin/systemctl $(TARGET_DIR)/sbin/shutdown
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
	- - render -1 * - - - DRI rendering nodes
	- - kvm -1 * - - - kvm nodes
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
# note that console-getty.service should be used on /dev/console as it should not have dependencies
# also patch the file to use the correct baud-rate, the default baudrate is 115200 so look for that
define SYSTEMD_INSTALL_SERVICE_TTY
	if [ $(BR2_TARGET_GENERIC_GETTY_PORT) = "console" ]; \
	then \
		TARGET="console-getty.service"; \
		LINK_NAME="console-getty.service"; \
	elif echo $(BR2_TARGET_GENERIC_GETTY_PORT) | egrep -q 'tty[0-9]*$$'; \
	then \
		TARGET="getty@.service"; \
		LINK_NAME="getty@$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)).service"; \
	else \
		TARGET="serial-getty@.service"; \
		LINK_NAME="serial-getty@$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)).service"; \
	fi; \
	ln -fs ../../../../lib/systemd/system/$${TARGET} \
		$(TARGET_DIR)/etc/systemd/system/getty.target.wants/$${LINK_NAME}; \
	if [ $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE)) -gt 0 ] ; \
	then \
		$(SED) 's,115200,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),' $(TARGET_DIR)/lib/systemd/system/$${TARGET}; \
	fi
endef
endif

define SYSTEMD_INSTALL_INIT_SYSTEMD
	$(SYSTEMD_DISABLE_SERVICE_TTY1)
	$(SYSTEMD_INSTALL_SERVICE_TTY)
	$(SYSTEMD_INSTALL_SERVICE_TIMESYNC)
	$(SYSTEMD_INSTALL_NETWORK_CONFS)
endef

SYSTEMD_CONF_ENV = $(HOST_UTF8_LOCALE_ENV)
SYSTEMD_NINJA_ENV = $(HOST_UTF8_LOCALE_ENV)

$(eval $(meson-package))
