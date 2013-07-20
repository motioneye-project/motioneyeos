#############################################################
#
# dropwatch
#
#############################################################

DROPWATCH_VERSION = 1.4
DROPWATCH_SOURCE = dropwatch-$(DROPWATCH_VERSION).tar.bz2
DROPWATCH_SITE = https://git.fedorahosted.org/cgit/dropwatch.git/snapshot/
DROPWATCH_DEPENDENCIES = readline libnl binutils
DROPWATCH_LICENSE = GPLv2+
DROPWATCH_LICENSE_FILE = COPYING

define DROPWATCH_INSTALL_TARGET_CMDS
  cp $(@D)/src/dropwatch $(TARGET_DIR)/usr/bin
endef

define DROPWATCH_BUILD_CMDS
  $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) build
endef

define DROPWATCH_CLEAN_CMDS
  $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean
endef

define DROPWATCH_UNINSTALL_CMDS
  rm -f $(TARGET_DIR)/usr/bin/dropwatch
endef

$(eval $(generic-package))
