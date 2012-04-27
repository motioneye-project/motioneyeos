#############################################################
#
# libnl
#
#############################################################

LIBNL_VERSION = 3.2.8
LIBNL_SITE = http://www.infradead.org/~tgr/libnl/files
LIBNL_INSTALL_STAGING = YES
LIBNL_DEPENDENCIES = host-bison
LIBNL_MAKE = $(MAKE1)

define LIBNL_UNINSTALL_TARGET_CMDS
	rm -r $(TARGET_DIR)/usr/lib/libnl.* $(TARGET_DIR)/usr/lib/libnl-*.*
	rm -rf $(TARGET_DIR)/usr/lib/libnl
endef

$(eval $(call AUTOTARGETS))
