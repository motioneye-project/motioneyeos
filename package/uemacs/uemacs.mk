################################################################################
#
# uemacs
#
################################################################################

UEMACS_VERSION = 1cdcf9df88144049750116e36fe20c8c39fa2517
UEMACS_SITE = https://git.kernel.org/pub/scm/editors/uemacs/uemacs.git
UEMACS_SITE_METHOD = git
UEMACS_DEPENDENCIES = ncurses
UEMACS_LICENSE = MicroEMACS copyright notice
UEMACS_LICENSE_FILES = README

define UEMACS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" DEFINES="-DAUTOCONF -DPOSIX -DUSG" \
		CFLAGS+="$(TARGET_CFLAGS) " LIBS="$(TARGET_CFLAGS) -lncurses"
endef

define UEMACS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/em $(TARGET_DIR)/usr/bin/em
endef

$(eval $(generic-package))
