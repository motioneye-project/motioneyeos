################################################################################
#
# opentyrian
#
################################################################################

OPENTYRIAN_VERSION = 2.1.20130907
OPENTYRIAN_SITE = http://www.camanis.net/opentyrian/releases/
OPENTYRIAN_SOURCE = opentyrian-$(OPENTYRIAN_VERSION)-src.tar.gz
OPENTYRIAN_LICENSE = GPLv2+
OPENTYRIAN_LICENSE_FILES = COPYING

OPENTYRIAN_DEPENDENCIES = sdl

ifeq ($(BR2_PACKAGE_OPENTYRIAN_NET),y)
OPENTYRIAN_DEPENDENCIES += sdl_net
OPENTYRIAN_NETWORK = true
else
OPENTYRIAN_NETWORK = false
endif

define OPENTYRIAN_BUILD_CMDS
        $(MAKE) PLATFORM=UNIX \
		CC="$(TARGET_CC)" \
		STRIP="/bin/true" \
		SDL_CONFIG="$(STAGING_DIR)/usr/bin/sdl-config" \
		LDFLAGS="-lm" \
		WITH_NETWORK="$(OPENTYRIAN_NETWORK)" \
		-C $(@D) release
endef

define OPENTYRIAN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/opentyrian $(TARGET_DIR)/usr/bin/opentyrian
endef

$(eval $(generic-package))
