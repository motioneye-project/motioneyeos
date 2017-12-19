################################################################################
#
# kexec-lite
#
################################################################################

KEXEC_LITE_VERSION = 86e45a47e8cc1f598ccfa9b873a23067f4ecc36f
KEXEC_LITE_SITE = $(call github,antonblanchard,kexec-lite,$(KEXEC_LITE_VERSION))
KEXEC_LITE_LICENSE = GPL-2.0+
KEXEC_LITE_LICENSE_FILES = COPYING
KEXEC_LITE_DEPENDENCIES = elfutils dtc

define KEXEC_LITE_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define KEXEC_LITE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/kexec $(TARGET_DIR)/usr/sbin/kexec
endef

$(eval $(generic-package))
