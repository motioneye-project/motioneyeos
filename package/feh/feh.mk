################################################################################
#
# feh
#
################################################################################

FEH_VERSION = 2.27.1
FEH_SOURCE = feh-$(FEH_VERSION).tar.bz2
FEH_SITE = http://feh.finalrewind.org
FEH_DEPENDENCIES = imlib2 libpng xlib_libXt
FEH_LICENSE = MIT
FEH_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBCURL),y)
FEH_DEPENDENCIES += libcurl
FEH_MAKE_OPTS += curl=1
else
FEH_MAKE_OPTS += curl=0
endif

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
FEH_DEPENDENCIES += libexif
FEH_MAKE_OPTS += exif=1
else
FEH_MAKE_OPTS += exif=0
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
FEH_DEPENDENCIES += xlib_libXinerama
FEH_MAKE_OPTS += xinerama=1
else
FEH_MAKE_OPTS += xinerama=0
endif

define FEH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) CFLAGS="$(TARGET_CFLAGS) -std=gnu99" \
		$(MAKE) $(FEH_MAKE_OPTS) -C $(@D) all
endef

define FEH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(FEH_MAKE_OPTS) PREFIX=/usr \
		DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
