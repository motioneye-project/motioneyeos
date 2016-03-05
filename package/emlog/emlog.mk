################################################################################
#
# emlog
#
################################################################################

EMLOG_VERSION = bd32494ad757c3d37469877aaf99ced3ee6ca3f8
EMLOG_SITE = $(call github,nicupavel,emlog,$(EMLOG_VERSION))
EMLOG_LICENSE = GPLv2
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
