################################################################################
#
# bcache-tools
#
################################################################################

BCACHE_TOOLS_VERSION = v1.0.8
BCACHE_TOOLS_SITE = $(call github,g2p,bcache-tools,$(BCACHE_TOOLS_VERSION))
BCACHE_TOOLS_LICENSE = GPLv2
BCACHE_TOOLS_LICENSE_FILES = COPYING
BCACHE_TOOLS_DEPENDENCIES = host-pkgconf util-linux

# We pass $(TARGET_CONFIGURE_OPTS) as environment variable to allow
# the bcache-tools Makefile to alter CFLAGS
define BCACHE_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

# The bcache-tools Makefile expects the man8 directory to exist
# expects the /lib/udev/rules.d directory to exist.
define BCACHE_TOOLS_CREATE_MISSING_DIRS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/usr/share/man/man8
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/lib/udev/rules.d
endef

BCACHE_TOOLS_PRE_INSTALL_TARGET_HOOKS += BCACHE_TOOLS_CREATE_MISSING_DIRS

define BCACHE_TOOLS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
