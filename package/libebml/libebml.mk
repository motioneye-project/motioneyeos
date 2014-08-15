################################################################################
#
# libebml
#
################################################################################

LIBEBML_VERSION = 1.2.2
LIBEBML_SOURCE = libebml-$(LIBEBML_VERSION).tar.bz2
LIBEBML_SITE = http://dl.matroska.org/downloads/libebml
LIBEBML_INSTALL_STAGING = YES
LIBEBML_LICENSE = LGPLv2.1+
LIBEBML_LICENSE_FILES = LICENSE.LGPL

ifeq ($(BR2_PREFER_STATIC_LIB),y)
LIBEBML_MAKE_TARGETS = staticlib
LIBEBML_MAKE_INSTALL_TARGETS = install_staticlib install_headers
else
LIBEBML_MAKE_TARGETS = staticlib sharedlib
LIBEBML_MAKE_INSTALL_TARGETS = install_staticlib install_sharedlib install_headers
endif

define LIBEBML_BUILD_CMDS
	$(MAKE) -C $(@D)/make/linux CROSS="$(CCACHE) $(TARGET_CROSS)" \
		$(LIBEBML_MAKE_TARGETS)
endef

define LIBEBML_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/make/linux prefix=$(STAGING_DIR)/usr \
		$(LIBEBML_MAKE_INSTALL_TARGETS)
endef

define LIBEBML_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/make/linux prefix=$(TARGET_DIR)/usr \
		$(LIBEBML_MAKE_INSTALL_TARGETS)
endef

$(eval $(generic-package))
