#############################################################
#
# LTTng-modules: the kernel modules (requires at least Linux 2.6.38)
#
#############################################################
LTTNG_MODULES_VERSION = 2.0.3
LTTNG_MODULES_SITE    = http://lttng.org/files/lttng-modules/
LTTNG_MODULES_SOURCE  = lttng-modules-$(LTTNG_MODULES_VERSION).tar.bz2

LTTNG_MODULES_DEPENDENCIES = linux

define LTTNG_MODULES_BUILD_CMDS
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNELDIR=$(LINUX_DIR)
endef

define LTTNG_MODULES_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNELDIR=$(LINUX_DIR) modules_install
endef

$(eval $(generic-package))
