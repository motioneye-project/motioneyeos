#############################################################
#
# nano
#
#############################################################

NANO_VERSION = 2.2.6
NANO_SITE = http://www.nano-editor.org/dist/v2.2
NANO_MAKE_ENV = CURSES_LIB="-lncurses"
NANO_CONF_OPT = --without-slang --enable-tiny
NANO_DEPENDENCIES = ncurses

define NANO_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/src/nano $(TARGET_DIR)/usr/bin/nano
endef

define NANO_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/nano
endef

$(eval $(call AUTOTARGETS,package,nano))
