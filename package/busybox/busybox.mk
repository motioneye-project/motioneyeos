#############################################################
#
# busybox
#
#############################################################

ifeq ($(BR2_PACKAGE_BUSYBOX_SNAPSHOT),y)
BUSYBOX_VERSION = snapshot
BUSYBOX_SITE = http://www.busybox.net/downloads/snapshots
else
BUSYBOX_VERSION = $(call qstrip,$(BR2_BUSYBOX_VERSION))
BUSYBOX_SITE = http://www.busybox.net/downloads
endif
BUSYBOX_SOURCE = busybox-$(BUSYBOX_VERSION).tar.bz2
BUSYBOX_BUILD_CONFIG = $(BUSYBOX_DIR)/.config
# Allows the build system to tweak CFLAGS
BUSYBOX_MAKE_ENV = $(TARGET_MAKE_ENV) CFLAGS="$(TARGET_CFLAGS) -I$(LINUX_HEADERS_DIR)/include"
BUSYBOX_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	ARCH=$(KERNEL_ARCH) \
	PREFIX="$(TARGET_DIR)" \
	EXTRA_LDFLAGS="$(TARGET_LDFLAGS)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CONFIG_PREFIX="$(TARGET_DIR)" \
	SKIP_STRIP=y

ifndef BUSYBOX_CONFIG_FILE
	BUSYBOX_CONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_BUSYBOX_CONFIG))
endif

# If we have external syslogd, force busybox to use it
ifeq ($(BR2_PACKAGE_SYSKLOGD),y)
define BUSYBOX_SET_SYSKLOGD
	@$(SED) "/#include.*busybox\.h/a#define CONFIG_SYSLOGD" \
		$(BUSYBOX_DIR)/init/init.c
endef
endif

# id applet breaks on >=1.13.0 with old uclibc unless the bb pwd routines are used
ifeq ($(BR2_BUSYBOX_VERSION_1_13_X)$(BR2_BUSYBOX_VERSION_1_14_X)$(BR2_UCLIBC_VERSION_0_9_29),yy)
define BUSYBOX_SET_BB_PWD
	if grep -q 'CONFIG_ID=y' $(BUSYBOX_BUILD_CONFIG); \
	then \
		echo 'warning: CONFIG_ID needs BB_PWD_GRP with old uclibc, enabling' >&2;\
		$(SED) "s/^.*CONFIG_USE_BB_PWD_GRP.*/CONFIG_USE_BB_PWD_GRP=y/;" $(BUSYBOX_BUILD_CONFIG); \
	fi
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

# If RPC is enabled then enable nfs mounts
ifeq ($(BR2_INET_RPC),y)
define BUSYBOX_SET_RPC
	$(call KCONFIG_ENABLE_OPT,CONFIG_FEATURE_MOUNT_NFS,$(BUSYBOX_BUILD_CONFIG))
endef
else
define BUSYBOX_SET_RPC
	$(call KCONFIG_DISABLE_OPT,CONFIG_FEATURE_MOUNT_NFS,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# If we're using static libs do the same for busybox
ifeq ($(BR2_PREFER_STATIC_LIB),y)
define BUSYBOX_PREFER_STATIC
	$(call KCONFIG_ENABLE_OPT,CONFIG_STATIC,$(BUSYBOX_BUILD_CONFIG))
endef
else
define BUSYBOX_PREFER_STATIC
	$(call KCONFIG_DISABLE_OPT,CONFIG_STATIC,$(BUSYBOX_BUILD_CONFIG))
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
	cp -f $(BUSYBOX_CONFIG_FILE) $(BUSYBOX_BUILD_CONFIG)
endef

# We do this here to avoid busting a modified .config in configure
BUSYBOX_POST_EXTRACT_HOOKS += BUSYBOX_COPY_CONFIG

define BUSYBOX_CONFIGURE_CMDS
	$(BUSYBOX_SET_SYSKLOGD)
	$(BUSYBOX_SET_BB_PWD)
	$(BUSYBOX_SET_LARGEFILE)
	$(BUSYBOX_SET_IPV6)
	$(BUSYBOX_SET_RPC)
	$(BUSYBOX_PREFER_STATIC)
	$(BUSYBOX_NETKITBASE)
	$(BUSYBOX_NETKITTELNET)
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
endef

define BUSYBOX_UNINSTALL_TARGET_CMDS
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) -C $(@D) uninstall
endef

define BUSYBOX_CLEAN_CMDS
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) -C $(@D) clean
endef

$(eval $(call GENTARGETS,package,busybox))

busybox-menuconfig:	$(BUSYBOX_DIR)/.stamp_extracted
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) -C $(BUSYBOX_DIR) menuconfig
	rm -f $(BUSYBOX_DIR)/.stamp_built
	rm -f $(BUSYBOX_DIR)/.stamp_target_installed

busybox-update:
	cp -f $(BUSYBOX_BUILD_CONFIG) $(BUSYBOX_CONFIG_FILE)
