################################################################################
#
# libmatroska
#
################################################################################

LIBMATROSKA_VERSION = 1.3.0
LIBMATROSKA_SOURCE = libmatroska-$(LIBMATROSKA_VERSION).tar.bz2
LIBMATROSKA_SITE = http://dl.matroska.org/downloads/libmatroska/
LIBMATROSKA_INSTALL_STAGING = YES
LIBMATROSKA_LICENSE = LGPLv2.1+
LIBMATROSKA_LICENSE_FILES = LICENSE.LGPL
LIBMATROSKA_DEPENDENCIES = libebml

define LIBMATROSKA_BUILD_CMDS
	$(MAKE) -C $(@D)/make/linux CROSS="$(CCACHE) $(TARGET_CROSS)"
endef

define LIBMATROSKA_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/make/linux prefix=$(STAGING_DIR)/usr install
endef

define LIBMATROSKA_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/make/linux prefix=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
