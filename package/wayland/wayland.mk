################################################################################
#
# wayland
#
################################################################################

WAYLAND_VERSION = 1.3.0
WAYLAND_SITE = http://wayland.freedesktop.org/releases/
WAYLAND_SOURCE = wayland-$(WAYLAND_VERSION).tar.xz
WAYLAND_LICENSE = MIT
WAYLAND_LICENSE_FILES = COPYING

WAYLAND_INSTALL_STAGING = YES
WAYLAND_DEPENDENCIES = libffi host-pkgconf expat host-expat

# wayland needs a wayland-scanner program to generate some of its
# source code. By default, it builds it with CC, so it doesn't work with
# cross-compilation. Therefore, we build it manually, and tell wayland
# that the tool is already available.
WAYLAND_CONF_OPT = --disable-scanner

define WAYLAND_BUILD_SCANNER
	(cd $(@D)/src/; \
		$(HOSTCC) $(HOST_CFLAGS) $(HOST_LDFLAGS) \
			-o wayland-scanner scanner.c wayland-util.c -lexpat; \
	 	$(INSTALL) -m 0755 -D wayland-scanner \
			$(HOST_DIR)/usr/bin/wayland-scanner)
endef

WAYLAND_POST_CONFIGURE_HOOKS += WAYLAND_BUILD_SCANNER

$(eval $(autotools-package))
