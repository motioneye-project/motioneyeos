################################################################################
#
# googlefontdirectory
#
################################################################################

GOOGLEFONTDIRECTORY_VERSION = 94dff3eaa9301b6640cccc63c56d6ff33d82882c
GOOGLEFONTDIRECTORY_SITE = $(call github,google,fonts,$(GOOGLEFONTDIRECTORY_VERSION))

GOOGLEFONTDIRECTORY_FONTS = \
	$(call qstrip,$(BR2_PACKAGE_GOOGLEFONTDIRECTORY_FONTS))

ifneq ($(filter apache/%,$(GOOGLEFONTDIRECTORY_FONTS)),)
GOOGLEFONTDIRECTORY_LICENSE += Apache-2.0
GOOGLEFONTDIRECTORY_LICENSE_FILES += $(addsuffix /LICENSE.txt,$(filter apache/%,$(GOOGLEFONTDIRECTORY_FONTS)))
endif

ifneq ($(filter ofl/%,$(GOOGLEFONTDIRECTORY_FONTS)),)
GOOGLEFONTDIRECTORY_LICENSE += OFL-1.1
GOOGLEFONTDIRECTORY_LICENSE_FILES += $(addsuffix /OFL.txt,$(filter ofl/%,$(GOOGLEFONTDIRECTORY_FONTS)))
endif

ifneq ($(filter ufl/%,$(GOOGLEFONTDIRECTORY_FONTS)),)
GOOGLEFONTDIRECTORY_LICENSE += UFL-1.1
GOOGLEFONTDIRECTORY_LICENSE_FILES += $(addsuffix /LICENCE.txt,$(filter ufl/%,$(GOOGLEFONTDIRECTORY_FONTS)))
endif

# check-package OverriddenVariable
GOOGLEFONTDIRECTORY_LICENSE := $(subst $(space),$(comma)$(space),$(GOOGLEFONTDIRECTORY_LICENSE))

define GOOGLEFONTDIRECTORY_INSTALL_TARGET_CMDS
	$(foreach d,$(GOOGLEFONTDIRECTORY_FONTS), \
		mkdir -p $(TARGET_DIR)/usr/share/fonts/$(notdir $(d))
		$(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/fonts/$(notdir $(d)) $(@D)/$(d)/*.ttf
	)
endef

$(eval $(generic-package))
