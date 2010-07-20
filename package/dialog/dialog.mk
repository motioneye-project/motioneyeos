#############################################################
#
# dialog
#
#############################################################
DIALOG_VERSION:=1.1-20100428
DIALOG_SOURCE:=dialog-$(DIALOG_VERSION).tgz
DIALOG_SITE:=ftp://invisible-island.net/dialog
DIALOG_CONF_OPT = --with-ncurses
DIALOG_DEPENDENCIES = ncurses

define DIALOG_INSTALL_TARGET_CMDS
	install -c $(@D)/dialog $(TARGET_DIR)/usr/bin/dialog
endef

define DIALOG_POST_CLEAN
	-$(MAKE) -C $(@D) clean
	rm -f $(TARGET_DIR)/usr/bin/dialog
endef

$(eval $(call AUTOTARGETS,package,dialog))
