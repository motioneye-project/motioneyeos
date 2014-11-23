################################################################################
#
# uemacs
#
################################################################################

UEMACS_VERSION = fa00fe882f719351fdf7a4c4100baf4f3eab4d61
UEMACS_SITE = $(BR2_KERNEL_MIRROR)/scm/linux/kernel/git/torvalds/uemacs.git
UEMACS_SITE_METHOD = git
UEMACS_DEPENDENCIES = ncurses

define UEMACS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" DEFINES="-DAUTOCONF -DPOSIX -DUSG" \
		CFLAGS+="$(TARGET_CFLAGS) " LIBS="$(TARGET_CFLAGS) -lncurses"
endef

define UEMACS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/em $(TARGET_DIR)/usr/bin/em
endef

$(eval $(generic-package))
