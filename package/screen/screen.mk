#############################################################
#
# screen
#
#############################################################

SCREEN_VERSION = 4.0.3
SCREEN_SITE = $(BR2_GNU_MIRROR)/screen
SCREEN_DEPENDENCIES = ncurses
SCREEN_CONF_ENV = ac_cv_header_elf_h=no ac_cv_header_dwarf_h=no
SCREEN_MAKE = $(MAKE1)
SCREEN_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) SCREEN=screen install_bin

$(eval $(call AUTOTARGETS))
