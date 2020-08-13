################################################################################
#
# nvme
#
################################################################################

NVME_VERSION = 1.9
NVME_SITE = $(call github,linux-nvme,nvme-cli,v$(NVME_VERSION))
NVME_LICENSE = GPL-2.0+
NVME_LICENSE_FILES = LICENSE

# Yes, LIBUUID=0 means libuuid support enabled.
# LIBUUID=1 means libuuid support disabled.
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
NVME_DEPENDENCIES += util-linux
NVME_MAKE_OPTS += LIBUUID=0
else
NVME_MAKE_OPTS += LIBUUID=1
endif

define NVME_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) \
		$(NVME_MAKE_OPTS) -C $(@D)
endef

define NVME_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(NVME_MAKE_OPTS) -C $(@D) \
		DESTDIR=$(TARGET_DIR) PREFIX=/usr install-bin
endef

$(eval $(generic-package))
