################################################################################
#
# libebml
#
################################################################################

LIBEBML_VERSION = 1.2.2
LIBEBML_SOURCE = libebml-$(LIBEBML_VERSION).tar.bz2
LIBEBML_SITE = http://dl.matroska.org/downloads/libebml/
LIBEBML_INSTALL_STAGING = YES
LIBEBML_LICENSE = LGPLv2.1+
LIBEBML_LICENSE_FILES = LICENSE.LGPL

define LIBEBML_BUILD_CMDS
	$(MAKE) -C $(@D)/make/linux CROSS="$(CCACHE) $(TARGET_CROSS)"
endef

define LIBEBML_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/make/linux prefix=$(STAGING_DIR)/usr install
endef

define LIBEBML_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/make/linux prefix=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
