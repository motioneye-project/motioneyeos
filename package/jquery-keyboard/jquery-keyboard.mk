################################################################################
#
# jquery-keyboard
#
################################################################################

JQUERY_KEYBOARD_VERSION = v1.18.12
JQUERY_KEYBOARD_SITE = $(call github,Mottie,Keyboard,$(JQUERY_KEYBOARD_VERSION))
JQUERY_KEYBOARD_LICENSE = MIT WTFPL
JQUERY_KEYBOARD_LICENSE_FILES = README.markdown

define JQUERY_KEYBOARD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/css/keyboard.css \
		$(TARGET_DIR)/var/www/css/keyboard.css
	$(INSTALL) -m 0644 $(@D)/js/jquery.keyboard*.js \
		$(TARGET_DIR)/var/www
	$(INSTALL) -m 0644 -D $(@D)/js/jquery.mousewheel.js \
		$(TARGET_DIR)/var/www/jquery.mousewheel.js
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/var/www/layouts
	$(INSTALL) -m 0644 $(@D)/layouts/*.js \
		$(TARGET_DIR)/var/www/layouts
endef

$(eval $(generic-package))
