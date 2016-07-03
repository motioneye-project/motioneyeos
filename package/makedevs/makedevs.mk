################################################################################
#
# makedevs
#
################################################################################

MAKEDEVS_LICENSE = GPLv2

HOST_MAKEDEVS_CFLAGS = $(HOST_CFLAGS)
HOST_MAKEDEVS_LDFLAGS = $(HOST_LDFLAGS)

ifeq ($(BR2_ROOTFS_DEVICE_TABLE_SUPPORTS_EXTENDED_ATTRIBUTES),y)
HOST_MAKEDEVS_DEPENDENCIES += host-libcap
HOST_MAKEDEVS_CFLAGS += -DEXTENDED_ATTRIBUTES
HOST_MAKEDEVS_LDFLAGS += -lcap
endif

define MAKEDEVS_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		package/makedevs/makedevs.c -o $(@D)/makedevs
endef

define MAKEDEVS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/makedevs $(TARGET_DIR)/usr/sbin/makedevs
endef

define HOST_MAKEDEVS_BUILD_CMDS
	$(HOSTCC) $(HOST_MAKEDEVS_CFLAGS) package/makedevs/makedevs.c \
		-o $(@D)/makedevs $(HOST_MAKEDEVS_LDFLAGS)
endef

define HOST_MAKEDEVS_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/makedevs $(HOST_DIR)/usr/bin/makedevs
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
