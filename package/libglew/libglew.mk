################################################################################
#
# libglew
#
################################################################################

LIBGLEW_VERSION = 2.1.0
LIBGLEW_SOURCE = glew-$(LIBGLEW_VERSION).tgz
LIBGLEW_SITE = http://sourceforge.net/projects/glew/files/glew/$(LIBGLEW_VERSION)
LIBGLEW_LICENSE = BSD-3-Clause, MIT
LIBGLEW_LICENSE_FILES = LICENSE.txt
LIBGLEW_INSTALL_STAGING = YES
LIBGLEW_DEPENDENCIES = libgl xlib_libX11 xlib_libXext xlib_libXi xlib_libXmu

# using $TARGET_CONFIGURE_OPTS breaks compilation
define LIBGLEW_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		GLEW_DEST="/usr" LIBDIR="/usr/lib" \
		AR="$(TARGET_AR)" CC="$(TARGET_CC)" \
		LD="$(TARGET_CC)" STRIP="$(TARGET_STRIP)" \
		POPT="$(TARGET_CFLAGS)" LDFLAGS.EXTRA="$(TARGET_LDFLAGS)"
endef

define LIBGLEW_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		GLEW_DEST="$(STAGING_DIR)/usr" LIBDIR="$(STAGING_DIR)/usr/lib" \
		$(TARGET_CONFIGURE_OPTS) install
endef

define LIBGLEW_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		GLEW_DEST="$(TARGET_DIR)/usr" LIBDIR="$(TARGET_DIR)/usr/lib" \
		$(TARGET_CONFIGURE_OPTS) install
endef

$(eval $(generic-package))
