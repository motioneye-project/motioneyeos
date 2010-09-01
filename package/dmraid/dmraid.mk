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

define DMRAID_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/$(DMRAID_SUBDIR)/tools/dmraid $(TARGET_DIR)/usr/sbin
	$(INSTALL) -m 0755 package/dmraid/dmraid.init $(TARGET_DIR)/etc/init.d/dmraid
endef

define DMRAID_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/dmraid $(TARGET_DIR)/etc/init.d/dmraid
endef

$(eval $(call AUTOTARGETS,package,dmraid))
