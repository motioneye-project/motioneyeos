################################################################################
#
# jquery-ui
#
################################################################################

JQUERY_UI_VERSION = 1.10.4
# Use buildroot mirror since upstream switched the zipfile and directory
# structure without bumping/renaming.
# Remember to switch back to jqueryui.com when bumping!
JQUERY_UI_SITE = http://sources.buildroot.net
JQUERY_UI_SOURCE = jquery-ui-$(JQUERY_UI_VERSION).zip
JQUERY_UI_LICENSE = MIT
JQUERY_UI_LICENSE_FILES = MIT-LICENSE.txt

define JQUERY_UI_EXTRACT_CMDS
	unzip -d $(@D) $(DL_DIR)/$(JQUERY_UI_SOURCE)
	mv $(@D)/jquery-ui-$(JQUERY_UI_VERSION)/* $(@D)
	$(RM) -r $(@D)/jquery-ui-$(JQUERY_UI_VERSION)
endef

define JQUERY_UI_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/ui/minified/jquery-ui.min.js \
		$(TARGET_DIR)/var/www/jquery-ui.js
	$(INSTALL) -m 0644 -D $(@D)/ui/minified/i18n/jquery-ui-i18n.min.js \
		$(TARGET_DIR)/var/www/jquery-ui-i18n.js
	$(INSTALL) -m 0644 -D $(@D)/themes/base/minified/jquery-ui.min.css \
		$(TARGET_DIR)/var/www/jquery-ui.css
	$(INSTALL) -d $(TARGET_DIR)/var/www/images
	cp -a $(@D)/themes/base/minified/images/*.png \
		$(TARGET_DIR)/var/www/images
	chmod 0644 $(TARGET_DIR)/var/www/images/*.png
endef

$(eval $(generic-package))
