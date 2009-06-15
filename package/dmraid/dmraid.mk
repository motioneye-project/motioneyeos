#############################################################
#
# dmraid
#
#############################################################
DMRAID_VERSION:=1.0.0.rc15
DMRAID_SOURCE:=dmraid-$(DMRAID_VERSION).tar.bz2
DMRAID_SITE:=http://people.redhat.com/~heinzm/sw/dmraid/src
DMRAID_SUBDIR:=$(DMRAID_VERSION)
# lib and tools race with parallel make
DMRAID_MAKE = $(MAKE1)
DMRAID_DEPENDENCIES:=lvm2
DMRAID_INSTALL_STAGING:=yes

$(eval $(call AUTOTARGETS,package,dmraid))

$(DMRAID_TARGET_INSTALL_TARGET): $(DMRAID_TARGET_INSTALL_STAGING)
	$(call MESSAGE,"Installing to target")
	$(INSTALL) -m 0755 $(STAGING_DIR)/usr/sbin/dmraid $(TARGET_DIR)/usr/sbin
	$(INSTALL) -m 0755 package/dmraid/dmraid.init $(TARGET_DIR)/etc/init.d/dmraid
	touch $@

ifeq ($(BR2_ENABLE_DEBUG),)
$(DMRAID_HOOK_POST_INSTALL): $(DMRAID_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/usr/sbin/dmraid
	touch $@
endif

$(DMRAID_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
#	makefile has no uninstall target..
#	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(DMRAID_DIR) uninstall
	rm -f $(TARGET_DIR)/usr/sbin/dmraid $(TARGET_DIR)/etc/init.d/dmraid
	rm -f $(DMRAID_TARGET_INSTALL_TARGET) $(DMRAID_HOOK_POST_INSTALL)
