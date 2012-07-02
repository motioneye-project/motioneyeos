KMOD_VERSION = 9
KMOD_SOURCE = kmod-$(KMOD_VERSION).tar.xz
KMOD_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/kernel/kmod/
KMOD_INSTALL_STAGING = YES
KMOD_DEPENDENCIES = host-pkg-config

ifeq ($(BR2_PACKAGE_ZLIB),y)
KMOD_DEPENDENCIES += zlib
KMOD_CONF_OPT += --with-zlib
endif

ifeq ($(BR2_PACKAGE_XZ),y)
KMOD_DEPENDENCIES += xz
KMOD_CONF_OPT += --with-xz
endif

ifeq ($(BR2_PACKAGE_KMOD_TOOLS),y)
# take precedence over busybox / module-init-tools implementations
KMOD_DEPENDENCIES += \
	$(if $(BR2_PACKAGE_BUSYBOX),busybox) \
	$(if $(BR2_PACKAGE_MODULE_INIT_TOOLS),module-init-tools)

define KMOD_INSTALL_TOOLS
	for i in depmod insmod lsmod modinfo modprobe rmmod; \
	do ln -sf ../usr/bin/kmod $(TARGET_DIR)/sbin/$$i; done
endef

KMOD_POST_INSTALL_TARGET_HOOKS += KMOD_INSTALL_TOOLS
else
KMOD_CONF_OPT += --disable-tools
endif

$(eval $(autotools-package))
