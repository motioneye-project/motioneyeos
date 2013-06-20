################################################################################
#
# feh
#
################################################################################

FEH_VERSION = 2.9.1
FEH_SOURCE = feh-$(FEH_VERSION).tar.bz2
FEH_SITE = http://feh.finalrewind.org/
FEH_DEPENDENCIES = libcurl giblib imlib2 libpng xlib_libXinerama xlib_libXt

define FEH_BUILD_CMDS
	$(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) all
endef

define FEH_INSTALL_TARGET_CMDS
	$(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) " \
		DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

define FEH_UNINSTALL_TARGET_CMDS
	$(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) " \
		DESTDIR=$(TARGET_DIR) -C $(@D) uninstall
endef

$(eval $(generic-package))
