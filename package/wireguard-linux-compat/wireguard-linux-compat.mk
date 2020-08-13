################################################################################
#
# wireguard
#
################################################################################

WIREGUARD_LINUX_COMPAT_VERSION = 1.0.20200623
WIREGUARD_LINUX_COMPAT_SITE = https://git.zx2c4.com/wireguard-linux-compat/snapshot
WIREGUARD_LINUX_COMPAT_SOURCE = wireguard-linux-compat-$(WIREGUARD_LINUX_COMPAT_VERSION).tar.xz
WIREGUARD_LINUX_COMPAT_LICENSE = GPL-2.0
WIREGUARD_LINUX_COMPAT_LICENSE_FILES = COPYING
WIREGUARD_LINUX_COMPAT_MODULE_SUBDIRS = src

define WIREGUARD_LINUX_COMPAT_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_INET)
	$(call KCONFIG_ENABLE_OPT,CONFIG_NET)
	$(call KCONFIG_ENABLE_OPT,CONFIG_NET_FOU)
	$(call KCONFIG_ENABLE_OPT,CONFIG_CRYPTO)
	$(call KCONFIG_ENABLE_OPT,CONFIG_CRYPTO_MANAGER)
endef

$(eval $(kernel-module))
$(eval $(generic-package))
