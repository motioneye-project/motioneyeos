################################################################################
#
# trace-cmd
#
################################################################################

TRACE_CMD_VERSION = trace-cmd-v2.2.1
TRACE_CMD_SITE = http://git.kernel.org/cgit/linux/kernel/git/rostedt/trace-cmd.git
TRACE_CMD_SITE_METHOD = git
TRACE_CMD_INSTALL_STAGING = YES
TRACE_CMD_LICENSE = GPLv2 LGPLv2.1
TRACE_CMD_LICENSE_FILES = COPYING COPYING.LIB

define TRACE_CMD_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE" \
		-C $(@D) all
endef

define TRACE_CMD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/trace-cmd $(TARGET_DIR)/usr/bin/trace-cmd
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/lib/trace-cmd/plugins
	$(INSTALL) -D -m 0755 $(@D)/plugin_*.so $(TARGET_DIR)/usr/lib/trace-cmd/plugins
endef

$(eval $(generic-package))
