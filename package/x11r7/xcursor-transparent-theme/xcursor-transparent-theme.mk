################################################################################
#
# xcursor-transparent-theme
#
################################################################################

XCURSOR_TRANSPARENT_THEME_VERSION = 0.1.1
XCURSOR_TRANSPARENT_THEME_SITE = http://downloads.yoctoproject.org/releases/matchbox/utils/
XCURSOR_TRANSPARENT_THEME_DEPENDENCIES = xlib_libXcursor host-xapp_xcursorgen
XCURSOR_TRANSPARENT_THEME_LICENSE = GPLv2
XCURSOR_TRANSPARENT_THEME_LICENSE_FILES = COPYING

define ICONS_DEFAULT_CONFIG_INSTALL
        $(INSTALL) -m 0755 -D package/x11r7/xcursor-transparent-theme/index.theme \
		$(TARGET_DIR)/usr/share/icons/default/index.theme
endef

XCURSOR_TRANSPARENT_THEME_POST_INSTALL_TARGET_HOOKS += ICONS_DEFAULT_CONFIG_INSTALL

$(eval $(autotools-package))
