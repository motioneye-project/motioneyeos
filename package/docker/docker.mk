################################################################################
#
# docker
#
################################################################################

DOCKER_VERSION = 1.5
DOCKER_SITE = http://icculus.org/openbox/2/docker
DOCKER_DEPENDENCIES = host-pkgconf libglib2 xlib_libX11

DOCKER_LICENSE = GPL-2.0+
# The 'or later' is specified at the end of the README, so include that one too.
DOCKER_LICENSE_FILES = COPYING README

define DOCKER_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		XLIBPATH=$(STAGING_DIR)/usr/lib
endef

define DOCKER_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		XLIBPATH=$(STAGING_DIR)/usr/lib PREFIX=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
