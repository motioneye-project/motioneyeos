################################################################################
#
# trace-cmd
#
################################################################################

TRACE_CMD_VERSION = trace-cmd-v2.6.1
TRACE_CMD_SITE = $(BR2_KERNEL_MIRROR)/scm/linux/kernel/git/rostedt/trace-cmd.git
TRACE_CMD_SITE_METHOD = git
TRACE_CMD_INSTALL_STAGING = YES
TRACE_CMD_LICENSE = GPL-2.0, LGPL-2.1
TRACE_CMD_LICENSE_FILES = COPYING COPYING.LIB

TRACE_CMD_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_AUDIT),y)
TRACE_CMD_DEPENDENCIES += audit
endif

ifeq ($(BR2_PACKAGE_PYTHON),y)
TRACE_CMD_DEPENDENCIES += python host-swig
TRACE_CMD_MAKE_OPTS = PYTHON_VERS=python
else ifeq ($(BR2_PACKAGE_PYTHON3),y)
TRACE_CMD_DEPENDENCIES += python3 host-swig
TRACE_CMD_MAKE_OPTS = PYTHON_VERS=python3
else
TRACE_CMD_MAKE_OPTS += NO_PYTHON=1
endif

# trace-cmd already defines _LARGEFILE64_SOURCE when necessary,
# redefining it on the command line causes build problems.
TRACE_CMD_CFLAGS = $(filter-out -D_LARGEFILE64_SOURCE,$(TARGET_CFLAGS))

# trace-cmd use CPPFLAGS to add some extra flags.
# But like for CFLAGS, $(TARGET_CPPFLAGS) contains _LARGEFILE64_SOURCE
# that causes build problems.
TRACE_CMD_CPPFLAGS = $(filter-out -D_LARGEFILE64_SOURCE,$(TARGET_CPPFLAGS))

define TRACE_CMD_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TRACE_CMD_CFLAGS)" \
		CPPFLAGS="$(TRACE_CMD_CPPFLAGS)" \
		$(TRACE_CMD_MAKE_OPTS) \
		-C $(@D) all
endef

define TRACE_CMD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/trace-cmd $(TARGET_DIR)/usr/bin/trace-cmd
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/lib/trace-cmd/plugins
	$(INSTALL) -D -m 0755 $(@D)/plugin_*.so $(TARGET_DIR)/usr/lib/trace-cmd/plugins
endef

$(eval $(generic-package))
