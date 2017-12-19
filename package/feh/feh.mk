################################################################################
#
# feh
#
################################################################################

FEH_VERSION = 2.21
FEH_SOURCE = feh-$(FEH_VERSION).tar.bz2
FEH_SITE = http://feh.finalrewind.org
FEH_DEPENDENCIES = libcurl imlib2 libpng xlib_libXinerama xlib_libXt
FEH_LICENSE = MIT
FEH_LICENSE_FILES = COPYING

define FEH_BUILD_CMDS
	$(TARGET_MAKE_ENV) CFLAGS="$(TARGET_CFLAGS) -std=gnu99" $(MAKE1) \
		CC="$(TARGET_CC) $(TARGET_LDFLAGS)" -C $(@D) all
endef

define FEH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) " \
		PREFIX=/usr DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
