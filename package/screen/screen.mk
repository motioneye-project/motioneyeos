#############################################################
#
# screen
#
#############################################################

SCREEN_VERSION = 4.0.3
SCREEN_SITE = $(BR2_GNU_MIRROR)/screen
SCREEN_DEPENDENCIES = ncurses
SCREEN_CONF_ENV = ac_cv_header_elf_h=no ac_cv_header_dwarf_h=no \
	CFLAGS="$(TARGET_CFLAGS) -DTERMINFO"
SCREEN_MAKE = $(MAKE1)
SCREEN_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) SCREEN=screen install_bin

define SCREEN_INSTALL_SCREENRC
	if [ ! -f $(TARGET_DIR)/etc/screenrc ]; then \
		$(INSTALL) -m 0755 -D $(@D)/etc/screenrc $(TARGET_DIR)/etc/screenrc; \
	fi
endef

SCREEN_POST_INSTALL_TARGET_HOOKS += SCREEN_INSTALL_SCREENRC

$(eval $(autotools-package))
