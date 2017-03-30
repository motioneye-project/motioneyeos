################################################################################
#
# latencytop
#
################################################################################

LATENCYTOP_VERSION = 0.5
LATENCYTOP_SITE = http://www.latencytop.org/download
LATENCYTOP_DEPENDENCIES = libglib2 ncurses
LATENCYTOP_LICENSE = GPL-2.0
LATENCYTOP_LICENSE_FILES = latencytop.c

# NOTE: GTK is heavy weight, we intentionally build the text (ncurses)
# version only
define LATENCYTOP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) HAS_GTK_GUI=
endef

define LATENCYTOP_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) install -C $(@D) DESTDIR=$(TARGET_DIR) HAS_GTK_GUI=
endef

$(eval $(generic-package))
