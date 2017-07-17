################################################################################
#
# nvme
#
################################################################################

NVME_VERSION = v1.3
NVME_SITE = $(call github,linux-nvme,nvme-cli,$(NVME_VERSION))
NVME_LICENSE = GPL-2.0+
NVME_LICENSE_FILES = LICENSE

# Yes LIBUDEV=0 means udev support enabled, LIBUDEV=1 means udev
# support disabled.
ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
NVME_DEPENDENCIES += udev
NVME_MAKE_OPTS += LIBUDEV=0
else
NVME_MAKE_OPTS += LIBUDEV=1
endif

# LIBUDEV=1 means that libudev is _disabled_
define NVME_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) \
		$(NVME_MAKE_OPTS) -C $(@D)
endef

define NVME_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		PREFIX=/usr install-bin
endef

$(eval $(generic-package))
