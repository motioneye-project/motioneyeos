################################################################################
#
# busybox
#
################################################################################

ifeq ($(BR2_PACKAGE_BUSYBOX_SNAPSHOT),y)
BUSYBOX_VERSION = snapshot
BUSYBOX_SITE = http://www.busybox.net/downloads/snapshots
else
BUSYBOX_VERSION = $(call qstrip,$(BR2_BUSYBOX_VERSION))
BUSYBOX_SITE = http://www.busybox.net/downloads
endif
BUSYBOX_SOURCE = busybox-$(BUSYBOX_VERSION).tar.bz2
BUSYBOX_LICENSE = GPLv2
BUSYBOX_LICENSE_FILES = LICENSE

BUSYBOX_CFLAGS = \
	$(TARGET_CFLAGS)

BUSYBOX_LDFLAGS = \
	$(TARGET_LDFLAGS)

# Link against libtirpc if available so that we can leverage its RPC
# support for NFS mounting with Busybox
ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
BUSYBOX_DEPENDENCIES += libtirpc
BUSYBOX_CFLAGS += -I$(STAGING_DIR)/usr/include/tirpc/
# Don't use LDFLAGS for -ltirpc, because LDFLAGS is used for
# the non-final link of modules as well.
BUSYBOX_CFLAGS_busybox += -ltirpc
endif

BUSYBOX_BUILD_CONFIG = $(BUSYBOX_DIR)/.config
# Allows the build system to tweak CFLAGS
BUSYBOX_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	CFLAGS="$(BUSYBOX_CFLAGS)" \
	CFLAGS_busybox="$(BUSYBOX_CFLAGS_busybox)"
BUSYBOX_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	ARCH=$(KERNEL_ARCH) \
	PREFIX="$(TARGET_DIR)" \
	EXTRA_LDFLAGS="$(BUSYBOX_LDFLAGS)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CONFIG_PREFIX="$(TARGET_DIR)" \
	SKIP_STRIP=y

ifndef BUSYBOX_CONFIG_FILE
	BUSYBOX_CONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_BUSYBOX_CONFIG))
endif

define BUSYBOX_PERMISSIONS
/bin/busybox			 f 4755	0 0 - - - - -
/usr/share/udhcpc/default.script f 755  0 0 - - - - -
endef

# If mdev will be used for device creation enable it and copy S10mdev to /etc/init.d
ifeq ($(BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_MDEV),y)
define BUSYBOX_INSTALL_MDEV_SCRIPT
	[ -f $(TARGET_DIR)/etc/init.d/S10mdev ] || \
		install -D -m 0755 package/busybox/S10mdev \
			$(TARGET_DIR)/etc/init.d/S10mdev
endef
define BUSYBOX_INSTALL_MDEV_CONF
	[ -f $(TARGET_DIR)/etc/mdev.conf ] || \
		install -D -m 0644 package/busybox/mdev.conf \
			$(TARGET_DIR)/etc/mdev.conf
endef
define BUSYBOX_SET_MDEV
	$(call KCONFIG_ENABLE_OPT,CONFIG_MDEV,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_FEATURE_MDEV_CONF,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_FEATURE_MDEV_EXEC,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_FEATURE_MDEV_LOAD_FIRMWARE,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# sha passwords need USE_BB_CRYPT_SHA
ifeq ($(BR2_TARGET_GENERIC_PASSWD_SHA256)$(BR2_TARGET_GENERIC_PASSWD_SHA512),y)
define BUSYBOX_SET_CRYPT_SHA
	$(call KCONFIG_ENABLE_OPT,CONFIG_USE_BB_CRYPT_SHA,$(BUSYBOX_BUILD_CONFIG))
endef
endif

ifeq ($(BR2_USE_MMU),y)
define BUSYBOX_SET_MMU
	$(call KCONFIG_DISABLE_OPT,CONFIG_NOMMU,$(BUSYBOX_BUILD_CONFIG))
endef
else
define BUSYBOX_SET_MMU
	$(call KCONFIG_ENABLE_OPT,CONFIG_NOMMU,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_DISABLE_OPT,CONFIG_SWAPONOFF,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_DISABLE_OPT,CONFIG_ASH,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH,$(BUSYBOX_BUILD_CONFIG))
endef
endif

ifeq ($(BR2_LARGEFILE),y)
define BUSYBOX_SET_LARGEFILE
	$(call KCONFIG_ENABLE_OPT,CONFIG_LFS,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_FDISK_SUPPORT_LARGE_DISKS,$(BUSYBOX_BUILD_CONFIG))
endef
else
define BUSYBOX_SET_LARGEFILE
	$(call KCONFIG_DISABLE_OPT,CONFIG_LFS,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_DISABLE_OPT,CONFIG_FDISK_SUPPORT_LARGE_DISKS,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# If IPv6 is enabled then enable basic ifupdown support for it
ifeq ($(BR2_INET_IPV6),y)
define BUSYBOX_SET_IPV6
	$(call KCONFIG_ENABLE_OPT,CONFIG_FEATURE_IPV6,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_FEATURE_IFUPDOWN_IPV6,$(BUSYBOX_BUILD_CONFIG))
endef
else
define BUSYBOX_SET_IPV6
	$(call KCONFIG_DISABLE_OPT,CONFIG_FEATURE_IPV6,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_DISABLE_OPT,CONFIG_FEATURE_IFUPDOWN_IPV6,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# If we're using static libs do the same for busybox
ifeq ($(BR2_PREFER_STATIC_LIB),y)
define BUSYBOX_PREFER_STATIC
	$(call KCONFIG_ENABLE_OPT,CONFIG_STATIC,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# Disable usage of inetd if netkit-base package is selected
ifeq ($(BR2_PACKAGE_NETKITBASE),y)
define BUSYBOX_NETKITBASE
	$(call KCONFIG_DISABLE_OPT,CONFIG_INETD,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# Disable usage of telnetd if netkit-telnetd package is selected
ifeq ($(BR2_PACKAGE_NETKITTELNET),y)
define BUSYBOX_NETKITTELNET
	$(call KCONFIG_DISABLE_OPT,CONFIG_TELNETD,$(BUSYBOX_BUILD_CONFIG))
endef
endif

define BUSYBOX_COPY_CONFIG
	$(INSTALL) -D -m 0644 $(BUSYBOX_CONFIG_FILE) $(BUSYBOX_BUILD_CONFIG)
endef

# Disable shadow passwords support if unsupported by the C library
ifeq ($(BR2_TOOLCHAIN_HAS_SHADOW_PASSWORDS),)
define BUSYBOX_INTERNAL_SHADOW_PASSWORDS
	$(call KCONFIG_ENABLE_OPT,CONFIG_USE_BB_PWD_GRP,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_USE_BB_SHADOW,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# We also need to use internal functions when using the musl C
# library, since some of them are not yet implemented by musl.
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
define BUSYBOX_INTERNAL_SHADOW_PASSWORDS
	$(call KCONFIG_ENABLE_OPT,CONFIG_USE_BB_PWD_GRP,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_USE_BB_SHADOW,$(BUSYBOX_BUILD_CONFIG))
endef
endif

ifeq ($(BR2_INIT_BUSYBOX),y)
define BUSYBOX_SET_INIT
	$(call KCONFIG_ENABLE_OPT,CONFIG_INIT,$(BUSYBOX_BUILD_CONFIG))
endef
endif

define BUSYBOX_INSTALL_LOGGING_SCRIPT
	if grep -q CONFIG_SYSLOGD=y $(@D)/.config; then \
		[ -f $(TARGET_DIR)/etc/init.d/S01logging ] || \
			$(INSTALL) -m 0755 -D package/busybox/S01logging \
				$(TARGET_DIR)/etc/init.d/S01logging; \
	else rm -f $(TARGET_DIR)/etc/init.d/S01logging; fi
endef

ifeq ($(BR2_PACKAGE_BUSYBOX_WATCHDOG),y)
define BUSYBOX_SET_WATCHDOG
        $(call KCONFIG_ENABLE_OPT,CONFIG_WATCHDOG,$(BUSYBOX_BUILD_CONFIG))
endef
define BUSYBOX_INSTALL_WATCHDOG_SCRIPT
	[ -f $(TARGET_DIR)/etc/init.d/S15watchdog ] || \
		install -D -m 0755 package/busybox/S15watchdog \
			$(TARGET_DIR)/etc/init.d/S15watchdog && \
		sed -i s/PERIOD/$(call qstrip,$(BR2_PACKAGE_BUSYBOX_WATCHDOG_PERIOD))/ \
			$(TARGET_DIR)/etc/init.d/S15watchdog
endef
endif

define BUSYBOX_CONFIGURE_CMDS
	$(BUSYBOX_COPY_CONFIG)
	$(BUSYBOX_SET_MMU)
	$(BUSYBOX_SET_LARGEFILE)
	$(BUSYBOX_SET_IPV6)
	$(BUSYBOX_PREFER_STATIC)
	$(BUSYBOX_SET_MDEV)
	$(BUSYBOX_SET_CRYPT_SHA)
	$(BUSYBOX_NETKITBASE)
	$(BUSYBOX_NETKITTELNET)
	$(BUSYBOX_INTERNAL_SHADOW_PASSWORDS)
	$(BUSYBOX_SET_INIT)
	$(BUSYBOX_SET_WATCHDOG)
	@yes "" | $(MAKE) ARCH=$(KERNEL_ARCH) CROSS_COMPILE="$(TARGET_CROSS)" \
		-C $(@D) oldconfig
endef

define BUSYBOX_BUILD_CMDS
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) -C $(@D)
endef

define BUSYBOX_INSTALL_TARGET_CMDS
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) -C $(@D) install
	if [ ! -f $(TARGET_DIR)/usr/share/udhcpc/default.script ]; then \
		$(INSTALL) -m 0755 -D package/busybox/udhcpc.script \
			$(TARGET_DIR)/usr/share/udhcpc/default.script; \
	fi
	$(BUSYBOX_INSTALL_MDEV_SCRIPT)
	$(BUSYBOX_INSTALL_MDEV_CONF)
	$(BUSYBOX_INSTALL_LOGGING_SCRIPT)
	$(BUSYBOX_INSTALL_WATCHDOG_SCRIPT)
endef

$(eval $(generic-package))

busybox-menuconfig busybox-xconfig busybox-gconfig: busybox-patch
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) -C $(BUSYBOX_DIR) \
		$(subst busybox-,,$@)
	rm -f $(BUSYBOX_DIR)/.stamp_built
	rm -f $(BUSYBOX_DIR)/.stamp_target_installed

busybox-update-config: busybox-configure
	cp -f $(BUSYBOX_BUILD_CONFIG) $(BUSYBOX_CONFIG_FILE)
