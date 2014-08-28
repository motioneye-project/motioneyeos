################################################################################
#
# kexec-lite
#
################################################################################

KEXEC_LITE_VERSION = fb8543fea3beb0522b5a63a74ea1a845dbd7b954
KEXEC_LITE_SITE = $(call github,antonblanchard,kexec-lite,$(KEXEC_LITE_VERSION))
KEXEC_LITE_LICENSE = GPLv2+
KEXEC_LITE_DEPENDENCIES = elfutils dtc

define KEXEC_LITE_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define KEXEC_LITE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/kexec $(TARGET_DIR)/usr/sbin/kexec
endef

$(eval $(generic-package))
