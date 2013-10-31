################################################################################
#
# uemacs
#
################################################################################

UEMACS_VERSION = 4.0.15-lt
UEMACS_SOURCE = em-$(UEMACS_VERSION).tar.gz
UEMACS_SITE = $(BR2_KERNEL_MIRROR)/software/editors/uemacs/
UEMACS_DEPENDENCIES = ncurses

define UEMACS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" DEFINES="-DAUTOCONF -DPOSIX -DUSG" \
		CFLAGS+="$(TARGET_CFLAGS) " LIBS="$(TARGET_CFLAGS) -lncurses"
endef

define UEMACS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/em $(TARGET_DIR)/usr/bin/em
endef

define UEMACS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/em
endef

$(eval $(generic-package))
