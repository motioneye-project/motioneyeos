################################################################################
#
# vmtouch
#
################################################################################

VMTOUCH_VERSION = v1.3.1
VMTOUCH_SITE = $(call github,hoytech,vmtouch,$(VMTOUCH_VERSION))
VMTOUCH_LICENSE = BSD-3-Clause
VMTOUCH_LICENSE_FILES = LICENSE

define VMTOUCH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define VMTOUCH_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) install \
		DESTDIR=$(TARGET_DIR) PREFIX=/usr
endef

$(eval $(generic-package))
