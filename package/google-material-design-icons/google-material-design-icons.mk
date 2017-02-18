################################################################################
#
# google-material-design-icons
#
################################################################################

GOOGLE_MATERIAL_DESIGN_ICONS_VERSION = 2.0.0
GOOGLE_MATERIAL_DESIGN_ICONS_SOURCE = \
	$(GOOGLE_MATERIAL_DESIGN_ICONS_VERSION).tar.gz
GOOGLE_MATERIAL_DESIGN_ICONS_SITE = \
	https://github.com/google/material-design-icons/archive
GOOGLE_MATERIAL_DESIGN_ICONS_LICENSE = CC-BY-4.0
GOOGLE_MATERIAL_DESIGN_ICONS_LICENSE_FILES = LICENSE

GOOGLE_MATERIAL_DESIGN_ICONS_LIST = \
	action alert av communication content device editor file \
	hardware image maps navigation notification social toggle

ifneq ($(BR2_PACKAGE_GOOGLE_MATERIAL_DESIGN_ICONS_TYPE_PNG)$(BR2_PACKAGE_GOOGLE_MATERIAL_DESIGN_ICONS_TYPE_SVG),)
define GOOGLE_MATERIAL_DESIGN_ICONS_INSTALL_ICONS_IMAGES
	$(foreach family,$(GOOGLE_MATERIAL_DESIGN_ICONS_LIST),\
		$(INSTALL) -d $(TARGET_DIR)/usr/share/google-material/$(family) \
			|| exit 1; \
		$(if $(BR2_PACKAGE_GOOGLE_MATERIAL_DESIGN_ICONS_TYPE_PNG), \
			$(INSTALL) -D -m 0644 $(@D)/$(family)/1x_web/*.png \
				$(TARGET_DIR)/usr/share/google-material/$(family) || exit 1;) \
		$(if $(BR2_PACKAGE_GOOGLE_MATERIAL_DESIGN_ICONS_TYPE_SVG), \
			$(INSTALL) -D -m 0644 $(@D)/$(family)/svg/production/*.svg \
				$(TARGET_DIR)/usr/share/google-material/$(family) || exit 1;) \
	)
endef
endif

ifeq ($(BR2_PACKAGE_GOOGLE_MATERIAL_DESIGN_ICONS_FONT),y)
define GOOGLE_MATERIAL_DESIGN_ICONS_INSTALL_ICONS_FONT
	$(INSTALL) -D -m 0644 $(@D)/iconfont/MaterialIcons-Regular.ttf \
		$(TARGET_DIR)/usr/share/fonts/google-material/MaterialIcons-Regular.ttf \
		|| exit 1
endef
endif

define GOOGLE_MATERIAL_DESIGN_ICONS_INSTALL_ICONS_SPRITES
	$(if $(BR2_PACKAGE_GOOGLE_MATERIAL_DESIGN_ICONS_SPRITES_CSS), \
		$(INSTALL) -d $(TARGET_DIR)/usr/share/google-material/css-sprite \
			|| exit 1; \
		$(INSTALL) -D -m 0644 $(@D)/sprites/css-sprite/* \
			$(TARGET_DIR)/usr/share/google-material/css-sprite || exit 1)
	$(if $(BR2_PACKAGE_GOOGLE_MATERIAL_DESIGN_ICONS_SPRITES_SVG), \
		$(INSTALL) -d $(TARGET_DIR)/usr/share/google-material/svg-sprite \
			|| exit 1; \
		$(INSTALL) -D -m 0644 $(@D)/sprites/svg-sprite/* \
			$(TARGET_DIR)/usr/share/google-material/svg-sprite || exit 1)
endef

define GOOGLE_MATERIAL_DESIGN_ICONS_INSTALL_TARGET_CMDS
	$(GOOGLE_MATERIAL_DESIGN_ICONS_INSTALL_ICONS_FONT)
	$(GOOGLE_MATERIAL_DESIGN_ICONS_INSTALL_ICONS_IMAGES)
	$(GOOGLE_MATERIAL_DESIGN_ICONS_INSTALL_ICONS_SPRITES)
endef

$(eval $(generic-package))
