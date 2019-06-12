################################################################################
#
# font-awesome
#
################################################################################

FONT_AWESOME_VERSION = 4.7.0
FONT_AWESOME_SITE = $(call github,FortAwesome,Font-Awesome,v$(FONT_AWESOME_VERSION))
FONT_AWESOME_LICENSE = OFL-1.1 (font), MIT (CSS, LESS and Sass files)
FONT_AWESOME_DIRECTORIES_LIST = css fonts less scss

define FONT_AWESOME_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/font-awesome/
	$(foreach d,$(FONT_AWESOME_DIRECTORIES_LIST),\
		cp -dpfr $(@D)/$(d) $(TARGET_DIR)/usr/share/font-awesome$(sep))
endef

$(eval $(generic-package))
