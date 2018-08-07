################################################################################
#
# c-periphery
#
################################################################################

C_PERIPHERY_VERSION = v1.1.3
C_PERIPHERY_SITE = $(call github,vsergeev,c-periphery,$(C_PERIPHERY_VERSION))
C_PERIPHERY_INSTALL_STAGING = YES
# only a static library
C_PERIPHERY_INSTALL_TARGET = NO
C_PERIPHERY_LICENSE = MIT
C_PERIPHERY_LICENSE_FILES = LICENSE

define C_PERIPHERY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

# There is no 'install' rule in the Makefile, so we handle things
# manually.
define C_PERIPHERY_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/periphery.a $(STAGING_DIR)/usr/lib/libc-periphery.a
	mkdir -p $(STAGING_DIR)/usr/include/c-periphery/
	cp -dpfr $(@D)/src/*.h $(STAGING_DIR)/usr/include/c-periphery/
endef

$(eval $(generic-package))
