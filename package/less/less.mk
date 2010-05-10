#############################################################
#
# less
#
#############################################################

LESS_VERSION = 436
LESS_SITE = http://www.greenwoodsoftware.com/less
LESS_DEPENDENCIES = ncurses

$(eval $(call AUTOTARGETS,package,less))

$(LESS_TARGET_INSTALL_TARGET):
	$(call MESSAGE,"Installing to target")
	$(INSTALL) -m 0755 $(LESS_DIR)/less \
		$(TARGET_DIR)/usr/bin/less
	touch $@

$(LESS_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/bin/less
	rm -f $(LESS_TARGET_INSTALL_TARGET) $(LESS_HOOK_POST_INSTALL)
