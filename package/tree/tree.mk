################################################################################
#
# tree
#
################################################################################

TREE_VERSION = 1.7.0
TREE_SOURCE = tree-$(TREE_VERSION).tgz
TREE_SITE = http://mama.indstate.edu/users/ice/tree/src
TREE_LICENSE = GPL-2.0+
TREE_LICENSE_FILES = LICENSE

define TREE_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define TREE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tree $(TARGET_DIR)/usr/bin/tree
endef

$(eval $(generic-package))
