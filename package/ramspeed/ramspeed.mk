################################################################################
#
# ramspeed
#
################################################################################

RAMSPEED_VERSION = 2.6.0
RAMSPEED_SITE = http://www.alasir.com/software/ramspeed
RAMSPEED_ARCH = $(if $(BR2_i386),i386)$(if $(BR2_x86_64),x86_64)
RAMSPEED_LICENSE = Alasir License
RAMSPEED_LICENSE_FILES = LICENCE

define RAMSPEED_BUILD_CMDS
	cp -f package/ramspeed/Makefile $(@D)
	$(TARGET_CONFIGURE_OPTS) make -C $(@D) $(RAMSPEED_ARCH)
endef

define RAMSPEED_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/ramspeed $(TARGET_DIR)/usr/bin/ramspeed
endef

$(eval $(generic-package))
