################################################################################
#
# kexec-lite
#
################################################################################

KEXEC_LITE_VERSION = 783fb4a811d0b0f8cc2ed68fa7872dcad56a3944
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
