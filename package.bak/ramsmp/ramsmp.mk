################################################################################
#
# ramsmp
#
################################################################################

RAMSMP_VERSION = 3.5.0
RAMSMP_SITE = http://www.alasir.com/software/ramspeed
RAMSMP_ARCH = $(if $(BR2_i386),i386)$(if $(BR2_x86_64),x86_64)
RAMSMP_LICENSE = Alasir License
RAMSMP_LICENSE_FILES = LICENCE

define RAMSMP_BUILD_CMDS
	cp -f package/ramsmp/Makefile $(@D)
	$(TARGET_CONFIGURE_OPTS) make -C $(@D) $(RAMSMP_ARCH)
endef

define RAMSMP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/ramsmp $(TARGET_DIR)/usr/bin/ramsmp
endef

$(eval $(generic-package))
