################################################################################
#
# ne10
#
################################################################################

NE10_VERSION = v1.0.0
NE10_SITE = $(call github,projectNe10,Ne10,$(NE10_VERSION))
NE10_LICENSE = BSD-3c or Apache-2.0
NE10_LICENSE_FILES = doc/LICENSE

NE10_CONF_OPTS = -DGNULINUX_PLATFORM=ON

ifeq ($(BR2_STATIC_LIBS),)
NE10_CONF_OPTS += \
	-DNE10_BUILD_SHARED=ON
endif

# The package does not have any install target, so have to provide
# INSTALL_STAGING_CMDS and INSTALL_TARGET_CMDS.

ifeq ($(BR2_STATIC_LIBS),)
define NE10_INSTALL_STAGING_SHARED_LIB
	cp -dpf $(@D)/modules/libNE10*.so* $(STAGING_DIR)/usr/lib/
endef
endif

define NE10_INSTALL_STAGING_CMDS
	cp -dpf $(@D)/inc/NE10*h $(STAGING_DIR)/usr/include/
	cp -dpf $(@D)/modules/libNE10.a $(STAGING_DIR)/usr/lib/
	$(NE10_INSTALL_STAGING_SHARED_LIB)
endef


define NE10_INSTALL_TARGET_CMDS
	cp -dpf $(@D)/modules/libNE10*.so* $(TARGET_DIR)/usr/lib/
endef

$(eval $(cmake-package))
