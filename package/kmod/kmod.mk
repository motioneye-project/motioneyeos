KMOD_VERSION = 6
KMOD_SOURCE = kmod-$(KMOD_VERSION).tar.xz
KMOD_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/kernel/kmod/
KMOD_INSTALL_STAGING = YES
KMOD_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS))
