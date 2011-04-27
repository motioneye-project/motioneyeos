#############################################################
#
# libnl
#
#############################################################

LIBNL_VERSION = 3.0
LIBNL_SOURCE = libnl-$(LIBNL_VERSION).tar.gz
LIBNL_SITE = http://www.infradead.org/~tgr/libnl/files/
LIBNL_INSTALL_STAGING = YES

define LIBNL_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/lib/libnl.so*
endef

$(eval $(call AUTOTARGETS,package,libnl))
