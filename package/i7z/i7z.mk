################################################################################
#
# i7z
#
################################################################################

I7Z_VERSION = 5023138d7c35c4667c938b853e5ea89737334e92
I7Z_SITE = $(call github,ajaiantilal,i7z,$(I7Z_VERSION))
I7Z_LICENSE = GPL-2.0
I7Z_LICENSE_FILES = COPYING
I7Z_DEPENDENCIES = ncurses

define I7Z_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define I7Z_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) install \
		DESTDIR="$(TARGET_DIR)"
endef

$(eval $(generic-package))
