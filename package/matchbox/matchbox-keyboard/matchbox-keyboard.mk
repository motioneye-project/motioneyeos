#############################################################
#
# MatchBox Keyboard
#
#############################################################

MATCHBOX_KEYBOARD_VERSION = 0.1
MATCHBOX_KEYBOARD_SOURCE = matchbox-keyboard-$(MATCHBOX_KEYBOARD_VERSION).tar.bz2
MATCHBOX_KEYBOARD_SITE = http://matchbox-project.org/sources/matchbox-keyboard/$(MATCHBOX_KEYBOARD_VERSION)
MATCHBOX_KEYBOARD_DEPENDENCIES = matchbox-lib matchbox-fakekey

# Workaround bug in configure script
MATCHBOX_KEYBOARD_CONF_ENV = expat=yes

define MATCHBOX_KEYBOARD_POST_INSTALL_FIXES
 cp -dpf ./package/matchbox/matchbox-keyboard/mb-applet-kbd-wrapper.sh $(TARGET_DIR)/usr/bin/
endef

MATCHBOX_KEYBOARD_POST_INSTALL_TARGET_HOOKS += MATCHBOX_KEYBOARD_POST_INSTALL_FIXES

#############################################################

ifeq ($(BR2_PACKAGE_PANGO),y)
  MATCHBOX_PKEYBOARD_CONF_OPT+=--enable-pango
else
  MATCHBOX_KEYBOARD_DEPENDENCIES+=xlib_libXft
endif

#############################################################

$(eval $(autotools-package))
