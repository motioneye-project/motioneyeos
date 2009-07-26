#############################################################
#
# bmon
#
#############################################################

BMON_VERSION = 2.1.0
BMON_SOURCE = bmon-$(BMON_VERSION).tar.gz
BMON_SITE = http://distfiles.gentoo.org/distfiles
BMON_DEPENDENCIES = ncurses uclibc
BMON_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,bmon))

$(BMON_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/bin/bmon
	rm -f $(BMON_TARGET_INSTALL_TARGET) $(BMON_HOOK_POST_INSTALL)
