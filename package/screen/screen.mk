#############################################################
#
# screen
#
#############################################################
SCREEN_VERSION = 4.0.2
SCREEN_SITE = $(BR2_GNU_MIRROR)/screen

SCREEN_DEPENDENCIES = ncurses

SCREEN_CONF_ENV = CFLAGS=-DSYSV=1

SCREEN_MAKE_OPT = -j1

SCREEN_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) SCREEN=screen install_bin

$(eval $(call AUTOTARGETS,package,screen))
