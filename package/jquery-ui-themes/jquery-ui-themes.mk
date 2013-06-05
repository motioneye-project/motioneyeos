################################################################################
#
# jquery-ui-themes
#
################################################################################

JQUERY_UI_THEMES_VERSION = 1.10.3
JQUERY_UI_THEMES_SITE = http://jqueryui.com/resources/download
JQUERY_UI_THEMES_SOURCE = jquery-ui-themes-$(JQUERY_UI_THEMES_VERSION).zip
JQUERY_UI_THEMES_LICENSE = MIT
JQUERY_UI_THEMES_LICENSE_FILES = MIT-LICENSE.txt
JQUERY_UI_THEMES_DEPENDENCIES = jquery-ui

define JQUERY_UI_THEMES_EXTRACT_CMDS
	unzip -d $(@D) $(DL_DIR)/$(JQUERY_UI_THEMES_SOURCE)
	mv $(@D)/jquery-ui-themes-$(JQUERY_UI_THEMES_VERSION)/* $(@D)
	$(RM) -r $(@D)/jquery-ui-themes-$(JQUERY_UI_THEMES_VERSION)
endef

define JQUERY_UI_THEMES_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D \
		$(@D)/themes/$(call qstrip,$(BR2_PACKAGE_JQUERY_UI_THEMES_THEME))/jquery-ui.css \
		$(TARGET_DIR)/var/www/jquery-ui.css
	$(INSTALL) -d $(TARGET_DIR)/var/www/images
	cp -a $(@D)/themes/$(call qstrip,$(BR2_PACKAGE_JQUERY_UI_THEMES_THEME))/images/*.png \
		$(TARGET_DIR)/var/www/images
	chmod 0644 $(TARGET_DIR)/var/www/images/*.png
endef

define JQUERY_UI_THEMES_UNINSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/var/www/jquery-ui.css
endef

$(eval $(generic-package))
