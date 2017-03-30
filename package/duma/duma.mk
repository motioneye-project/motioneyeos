################################################################################
#
# duma
#
################################################################################

DUMA_VERSION = 2.5.15
DUMA_SOURCE = duma_$(subst .,_,$(DUMA_VERSION)).tar.gz
DUMA_SITE = http://downloads.sourceforge.net/project/duma/duma/$(DUMA_VERSION)
DUMA_LICENSE = GPL-2.0+, LGPL-2.1+
DUMA_LICENSE_FILES = COPYING-GPL COPYING-LGPL

DUMA_INSTALL_STAGING = YES

DUMA_OPTIONS = \
	$(if $(BR2_PACKAGE_DUMA_NO_LEAKDETECTION),-DDUMA_LIB_NO_LEAKDETECTION)

# The dependency of some source files in duma_config.h, which is generated at
# build time, is not specified in the Makefile. Force non-parallel build.
define DUMA_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS)       \
		OS=linux \
		DUMA_OPTIONS="$(DUMA_OPTIONS)"   \
		$(DUMA_CPP) -C $(@D)
endef

define DUMA_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) OS=linux prefix=$(STAGING_DIR)/usr install -C $(@D)
endef

define DUMA_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) OS=linux prefix=$(TARGET_DIR)/usr install -C $(@D)
endef

$(eval $(generic-package))
