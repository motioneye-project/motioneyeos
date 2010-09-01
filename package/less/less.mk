#############################################################
#
# less
#
#############################################################

LESS_VERSION = 436
LESS_SITE = http://www.greenwoodsoftware.com/less
LESS_DEPENDENCIES = ncurses

define LESS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/less $(TARGET_DIR)/usr/bin/less
endef

define LESS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/less
endef

$(eval $(call AUTOTARGETS,package,less))
