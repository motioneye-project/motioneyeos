################################################################################
#
# matchbox-keyboard
#
################################################################################

MATCHBOX_KEYBOARD_VERSION = 0.1
MATCHBOX_KEYBOARD_SOURCE = matchbox-keyboard-$(MATCHBOX_KEYBOARD_VERSION).tar.bz2
MATCHBOX_KEYBOARD_SITE = http://downloads.yoctoproject.org/releases/matchbox/matchbox-keyboard/$(MATCHBOX_KEYBOARD_VERSION)
MATCHBOX_KEYBOARD_LICENSE = GPLv2+
MATCHBOX_KEYBOARD_LICENSE_FILES = COPYING
MATCHBOX_KEYBOARD_DEPENDENCIES = host-pkgconf matchbox-lib matchbox-fakekey expat

# Workaround bug in configure script
MATCHBOX_KEYBOARD_CONF_ENV = expat=yes

define MATCHBOX_KEYBOARD_POST_INSTALL_FIXES
	$(INSTALL) -D -m 0755 package/matchbox/matchbox-keyboard/mb-applet-kbd-wrapper.sh $(TARGET_DIR)/usr/bin/mb-applet-kbd-wrapper.sh
endef

MATCHBOX_KEYBOARD_POST_INSTALL_TARGET_HOOKS += MATCHBOX_KEYBOARD_POST_INSTALL_FIXES

ifeq ($(BR2_PACKAGE_CAIRO),y)
MATCHBOX_KEYBOARD_CONF_OPTS += --enable-cairo
MATCHBOX_KEYBOARD_DEPENDENCIES += cairo
else
MATCHBOX_KEYBOARD_DEPENDENCIES += xlib_libXft
endif

$(eval $(autotools-package))
