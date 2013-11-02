################################################################################
#
# ne10
#
################################################################################

# We use a Git commit ID because the last tagged version is more than
# one year old.
NE10_VERSION = 88c18f02199947b2c8b57796f5a3ca53160aff96
NE10_SITE = http://github.com/projectNe10/Ne10/tarball/$(NE10_VERSION)
NE10_LICENSE = BSD-3c or Apache 2.0
NE10_LICENSE_FILES = doc/LICENSE

ifeq ($(BR2_PREFER_STATIC_LIB),)
NE10_CONF_OPT = \
	-DNE10_BUILD_SHARED=ON
endif

# The package does not have any install target, so have to provide
# INSTALL_STAGING_CMDS and INSTALL_TARGET_CMDS.

ifeq ($(BR2_PREFER_STATIC_LIB),)
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
