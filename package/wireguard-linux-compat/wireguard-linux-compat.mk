################################################################################
#
# wireguard
#
################################################################################

WIREGUARD_LINUX_COMPAT_VERSION = 0.0.20200215
WIREGUARD_LINUX_COMPAT_SITE = https://git.zx2c4.com/wireguard-linux-compat/snapshot
WIREGUARD_LINUX_COMPAT_SOURCE = wireguard-linux-compat-$(WIREGUARD_LINUX_COMPAT_VERSION).tar.xz
WIREGUARD_LINUX_COMPAT_LICENSE = GPL-2.0
WIREGUARD_LINUX_COMPAT_LICENSE_FILES = COPYING
WIREGUARD_LINUX_COMPAT_MODULE_SUBDIRS = src

$(eval $(kernel-module))
$(eval $(generic-package))
