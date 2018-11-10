################################################################################
#
# kexec-lite
#
################################################################################

KEXEC_LITE_VERSION = 87d044a895b1c004320a2676099a54a5a2a74f2e
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
