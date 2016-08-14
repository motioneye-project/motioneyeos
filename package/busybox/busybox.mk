################################################################################
#
# busybox
#
################################################################################

BUSYBOX_VERSION = 1.24.2
BUSYBOX_SITE = http://www.busybox.net/downloads
BUSYBOX_SOURCE = busybox-$(BUSYBOX_VERSION).tar.bz2
BUSYBOX_LICENSE = GPLv2
BUSYBOX_LICENSE_FILES = LICENSE

BUSYBOX_CFLAGS = \
	$(TARGET_CFLAGS)

BUSYBOX_LDFLAGS = \
	$(TARGET_LDFLAGS)

# Link against libtirpc if available so that we can leverage its RPC
# support for NFS mounting with BusyBox
ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
BUSYBOX_DEPENDENCIES += libtirpc host-pkgconf
BUSYBOX_CFLAGS += "`$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`"
# Don't use LDFLAGS for -ltirpc, because LDFLAGS is used for
# the non-final link of modules as well.
BUSYBOX_CFLAGS_busybox += "`$(PKG_CONFIG_HOST_BINARY) --libs libtirpc`"
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

BUSYBOX_KCONFIG_FILE = $(BUSYBOX_CONFIG_FILE)
BUSYBOX_KCONFIG_FRAGMENT_FILES = $(call qstrip,$(BR2_PACKAGE_BUSYBOX_CONFIG_FRAGMENT_FILES))
BUSYBOX_KCONFIG_EDITORS = menuconfig xconfig gconfig
BUSYBOX_KCONFIG_OPTS = $(BUSYBOX_MAKE_OPTS)

define BUSYBOX_PERMISSIONS
	/bin/busybox                     f 4755 0  0 - - - - -
endef

# If mdev will be used for device creation enable it and copy S10mdev to /etc/init.d
ifeq ($(BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_MDEV),y)
define BUSYBOX_INSTALL_MDEV_SCRIPT
	$(INSTALL) -D -m 0755 package/busybox/S10mdev \
		$(TARGET_DIR)/etc/init.d/S10mdev
endef
define BUSYBOX_INSTALL_MDEV_CONF
	$(INSTALL) -D -m 0644 package/busybox/mdev.conf \
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
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_BASH_COMPAT,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_BRACE_EXPANSION,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_HELP,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_INTERACTIVE,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_SAVEHISTORY,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_JOB,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_TICK,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_IF,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_LOOPS,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_CASE,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_FUNCTIONS,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_LOCAL,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_RANDOM_SUPPORT,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_EXPORT_N,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_HUSH_MODE_X,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# If we're using static libs do the same for busybox
ifeq ($(BR2_STATIC_LIBS),y)
define BUSYBOX_PREFER_STATIC
	$(call KCONFIG_ENABLE_OPT,CONFIG_STATIC,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# Disable shadow passwords support if unsupported by the C library
ifeq ($(BR2_TOOLCHAIN_HAS_SHADOW_PASSWORDS),)
define BUSYBOX_INTERNAL_SHADOW_PASSWORDS
	$(call KCONFIG_ENABLE_OPT,CONFIG_USE_BB_PWD_GRP,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_USE_BB_SHADOW,$(BUSYBOX_BUILD_CONFIG))
endef
endif

# We also need to use internal shadow password functions when using
# the musl C library, since some of them are not yet implemented by
# musl.
#
# Do not use utmp/wmtp support. wmtp support is not available in musl,
# and utmp support is not sufficient for Busybox.
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
define BUSYBOX_MUSL_TWEAKS
	$(call KCONFIG_ENABLE_OPT,CONFIG_USE_BB_PWD_GRP,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_USE_BB_SHADOW,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_DISABLE_OPT,CONFIG_FEATURE_UTMP,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_DISABLE_OPT,CONFIG_FEATURE_WTMP,$(BUSYBOX_BUILD_CONFIG))
endef
endif

define BUSYBOX_INSTALL_UDHCPC_SCRIPT
	if grep -q CONFIG_UDHCPC=y $(@D)/.config; then \
		$(INSTALL) -m 0755 -D package/busybox/udhcpc.script \
			$(TARGET_DIR)/usr/share/udhcpc/default.script; \
		$(INSTALL) -m 0755 -d \
			$(TARGET_DIR)/usr/share/udhcpc/default.script.d; \
	fi
endef

ifeq ($(BR2_INIT_BUSYBOX),y)
define BUSYBOX_SET_INIT
	$(call KCONFIG_ENABLE_OPT,CONFIG_INIT,$(BUSYBOX_BUILD_CONFIG))
endef
endif

ifeq ($(BR2_PACKAGE_BUSYBOX_SELINUX),y)
BUSYBOX_DEPENDENCIES += host-pkgconf libselinux libsepol
define BUSYBOX_SET_SELINUX
	$(call KCONFIG_ENABLE_OPT,CONFIG_SELINUX,$(BUSYBOX_BUILD_CONFIG))
	$(call KCONFIG_ENABLE_OPT,CONFIG_SELINUXENABLED,$(BUSYBOX_BUILD_CONFIG))
endef
endif

define BUSYBOX_INSTALL_LOGGING_SCRIPT
	if grep -q CONFIG_SYSLOGD=y $(@D)/.config; then \
		$(INSTALL) -m 0755 -D package/busybox/S01logging \
			$(TARGET_DIR)/etc/init.d/S01logging; \
	else rm -f $(TARGET_DIR)/etc/init.d/S01logging; fi
endef

ifeq ($(BR2_INIT_BUSYBOX),y)
define BUSYBOX_INSTALL_INITTAB
	$(INSTALL) -D -m 0644 package/busybox/inittab $(TARGET_DIR)/etc/inittab
endef
endif

ifeq ($(BR2_PACKAGE_BUSYBOX_WATCHDOG),y)
define BUSYBOX_SET_WATCHDOG
	$(call KCONFIG_ENABLE_OPT,CONFIG_WATCHDOG,$(BUSYBOX_BUILD_CONFIG))
endef
define BUSYBOX_INSTALL_WATCHDOG_SCRIPT
	$(INSTALL) -D -m 0755 package/busybox/S15watchdog \
		$(TARGET_DIR)/etc/init.d/S15watchdog
	$(SED) s/PERIOD/$(call qstrip,$(BR2_PACKAGE_BUSYBOX_WATCHDOG_PERIOD))/ \
		$(TARGET_DIR)/etc/init.d/S15watchdog
endef
endif

# PAM support requires thread support in the toolchain
ifeq ($(BR2_PACKAGE_LINUX_PAM)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
define BUSYBOX_LINUX_PAM
	$(call KCONFIG_ENABLE_OPT,CONFIG_PAM,$(BUSYBOX_BUILD_CONFIG))
endef
BUSYBOX_DEPENDENCIES += linux-pam
endif

# Telnet support
define BUSYBOX_INSTALL_TELNET_SCRIPT
	if grep -q CONFIG_FEATURE_TELNETD_STANDALONE=y $(@D)/.config; then \
		$(INSTALL) -m 0755 -D package/busybox/S50telnet \
			$(TARGET_DIR)/etc/init.d/S50telnet ; \
	fi
endef

# Enable "noclobber" in install.sh, to prevent BusyBox from overwriting any
# full-blown versions of apps installed by other packages with sym/hard links.
define BUSYBOX_NOCLOBBER_INSTALL
	$(SED) 's/^noclobber="0"$$/noclobber="1"/' $(@D)/applets/install.sh
endef

define BUSYBOX_KCONFIG_FIXUP_CMDS
	$(BUSYBOX_SET_MMU)
	$(BUSYBOX_PREFER_STATIC)
	$(BUSYBOX_SET_MDEV)
	$(BUSYBOX_SET_CRYPT_SHA)
	$(BUSYBOX_LINUX_PAM)
	$(BUSYBOX_INTERNAL_SHADOW_PASSWORDS)
	$(BUSYBOX_SET_INIT)
	$(BUSYBOX_SET_WATCHDOG)
	$(BUSYBOX_SET_SELINUX)
	$(BUSYBOX_MUSL_TWEAKS)
endef

define BUSYBOX_CONFIGURE_CMDS
	$(BUSYBOX_NOCLOBBER_INSTALL)
endef

define BUSYBOX_BUILD_CMDS
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) -C $(@D)
endef

define BUSYBOX_INSTALL_TARGET_CMDS
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) -C $(@D) install
	$(BUSYBOX_INSTALL_INITTAB)
	$(BUSYBOX_INSTALL_UDHCPC_SCRIPT)
	$(BUSYBOX_INSTALL_MDEV_CONF)
endef

define BUSYBOX_INSTALL_INIT_SYSV
	$(BUSYBOX_INSTALL_MDEV_SCRIPT)
	$(BUSYBOX_INSTALL_LOGGING_SCRIPT)
	$(BUSYBOX_INSTALL_WATCHDOG_SCRIPT)
	$(BUSYBOX_INSTALL_TELNET_SCRIPT)
endef

# Checks to give errors that the user can understand
# Must be before we call to kconfig-package
ifeq ($(BR2_PACKAGE_BUSYBOX)$(BR_BUILDING),yy)
ifeq ($(call qstrip,$(BR2_PACKAGE_BUSYBOX_CONFIG)),)
$(error No BusyBox configuration file specified, check your BR2_PACKAGE_BUSYBOX_CONFIG setting)
endif
endif

$(eval $(kconfig-package))
