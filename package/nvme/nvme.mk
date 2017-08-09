################################################################################
#
# nvme
#
################################################################################

NVME_VERSION = v1.3
NVME_SITE = $(call github,linux-nvme,nvme-cli,$(NVME_VERSION))
NVME_LICENSE = GPL-2.0+
NVME_LICENSE_FILES = LICENSE

define NVME_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define NVME_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		PREFIX=/usr install-bin
endef

$(eval $(generic-package))
