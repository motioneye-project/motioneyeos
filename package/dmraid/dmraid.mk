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
DMRAID_INSTALL_STAGING = YES
DMRAID_UNINSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) remove
DMRAID_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

DMRAID_DEPENDENCIES = lvm2

define DMRAID_INSTALL_INITSCRIPT
	$(INSTALL) -m 0755 package/dmraid/dmraid.init $(TARGET_DIR)/etc/init.d/S20dmraid
endef

DMRAID_POST_INSTALL_TARGET_HOOKS += DMRAID_INSTALL_INITSCRIPT

define DMRAID_UNINSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) remove -C $(@D)/$(DMRAID_SUBDIR)
	rm -f $(TARGET_DIR)/etc/init.d/S20dmraid
endef

$(eval $(autotools-package))
