#############################################################
#
# libnl
#
#############################################################

LIBNL_VERSION = 1.1
LIBNL_SOURCE = libnl-$(LIBNL_VERSION).tar.gz
LIBNL_SITE = http://distfiles.gentoo.org/distfiles
LIBNL_INSTALL_STAGING = YES
LIBNL_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

define LIBNL_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/lib/libnl.so*
endef

$(eval $(call AUTOTARGETS,package,libnl))
