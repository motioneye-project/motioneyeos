################################################################################
#
# emlog
#
################################################################################

EMLOG_VERSION = 576a6c0fcf76dfeff48124b2f5fc0b4207d88ca1
EMLOG_SITE = $(call github,nicupavel,emlog,$(EMLOG_VERSION))
EMLOG_LICENSE = GPL-2.0
EMLOG_LICENSE_FILES = COPYING

define EMLOG_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) nbcat
endef

# make install tries to strip, so install manually.
define EMLOG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/nbcat $(TARGET_DIR)/usr/bin/nbcat
endef

$(eval $(kernel-module))
$(eval $(generic-package))
