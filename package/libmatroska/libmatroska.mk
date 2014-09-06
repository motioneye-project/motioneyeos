################################################################################
#
# libmatroska
#
################################################################################

LIBMATROSKA_VERSION = 1.3.0
LIBMATROSKA_SOURCE = libmatroska-$(LIBMATROSKA_VERSION).tar.bz2
LIBMATROSKA_SITE = http://dl.matroska.org/downloads/libmatroska
LIBMATROSKA_INSTALL_STAGING = YES
LIBMATROSKA_LICENSE = LGPLv2.1+
LIBMATROSKA_LICENSE_FILES = LICENSE.LGPL
LIBMATROSKA_DEPENDENCIES = libebml

ifeq ($(BR2_PREFER_STATIC_LIB),y)
LIBMATROSKA_MAKE_TARGETS = staticlib
LIBMATROSKA_MAKE_INSTALL_TARGETS = install_staticlib install_headers
else
LIBMATROSKA_MAKE_TARGETS = staticlib sharedlib
LIBMATROSKA_MAKE_INSTALL_TARGETS = install_staticlib install_sharedlib install_headers
endif

define LIBMATROSKA_BUILD_CMDS
	$(MAKE) -C $(@D)/make/linux CROSS="$(CCACHE) $(TARGET_CROSS)" \
		$(LIBMATROSKA_MAKE_TARGETS)
endef

define LIBMATROSKA_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/make/linux prefix=$(STAGING_DIR)/usr \
		$(LIBMATROSKA_MAKE_INSTALL_TARGETS)
endef

define LIBMATROSKA_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/make/linux prefix=$(TARGET_DIR)/usr \
		$(LIBMATROSKA_MAKE_INSTALL_TARGETS)
endef

$(eval $(generic-package))
