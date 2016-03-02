################################################################################
#
# nvme
#
################################################################################

NVME_VERSION = v0.3
NVME_SITE = $(call github,linux-nvme,nvme-cli,$(NVME_VERSION))
NVME_LICENSE = GPLv2+
NVME_LICENSE_FILES = COPYING

# LIBUDEV=1 means that libudev is _disabled_
define NVME_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) \
		LIBUDEV=1 -C $(@D)
endef

define NVME_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		PREFIX=/usr install-bin
endef

$(eval $(generic-package))
