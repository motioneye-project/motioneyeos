################################################################################
#
# feh
#
################################################################################

FEH_VERSION = 2.22.2
FEH_SOURCE = feh-$(FEH_VERSION).tar.bz2
FEH_SITE = http://feh.finalrewind.org
FEH_DEPENDENCIES = libcurl imlib2 libpng xlib_libXinerama xlib_libXt
FEH_LICENSE = MIT
FEH_LICENSE_FILES = COPYING

define FEH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) CFLAGS="$(TARGET_CFLAGS) -std=gnu99" \
		$(MAKE) -C $(@D) all
endef

define FEH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX=/usr DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
