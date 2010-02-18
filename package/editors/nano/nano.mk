#############################################################
#
# nano
#
#############################################################

NANO_VERSION = 2.2.3
NANO_SITE = http://www.nano-editor.org/dist/v2.2
NANO_MAKE_ENV = CURSES_LIB="-lncurses"
NANO_CONF_OPT = --without-slang --enable-tiny
NANO_DEPENDENCIES = ncurses

$(eval $(call AUTOTARGETS,package,nano))

$(NANO_TARGET_INSTALL_TARGET):
	$(call MESSAGE,"Installing to target")
	$(INSTALL) -m 0755 $(NANO_DIR)/src/nano \
		$(TARGET_DIR)/usr/bin/nano
	touch $@

$(NANO_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/bin/nano
	rm -f $(NANO_TARGET_INSTALL_TARGET) $(NANO_HOOK_POST_INSTALL)
