#############################################################
#
# gdisk
#
#############################################################

GDISK_VERSION = 0.6.14
GDISK_SITE = http://downloads.sourceforge.net/project/gptfdisk/gptfdisk/$(GDISK_VERSION)
GDISK_SOURCE = gdisk-$(GDISK_VERSION).tgz

GDISK_TARGETS_$(BR2_PACKAGE_GDISK_GDISK) += gdisk
GDISK_TARGETS_$(BR2_PACKAGE_GDISK_SGDISK) += sgdisk

ifneq ($(GDISK_TARGETS_y),)

GDISK_DEPENDENCIES += util-linux
ifeq ($(BR2_PACKAGE_GDISK_SGDISK),y)
    GDISK_DEPENDENCIES += popt
endif


define GDISK_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" \
		-C $(@D) $(GDISK_TARGETS_y)
endef

define GDISK_INSTALL_TARGET_CMDS
	for i in $(GDISK_TARGETS_y); do \
	    $(INSTALL) -D $(@D)/$$i $(TARGET_DIR)/usr/sbin/; \
	done
endef

define GDISK_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,$(GDISK_TARGETS_y))
endef

endif

$(eval $(generic-package))
