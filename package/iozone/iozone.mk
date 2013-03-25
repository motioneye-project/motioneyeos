#############################################################
#
# IOZONE
#
#############################################################

IOZONE_VERSION = 3_414
IOZONE_SOURCE = iozone$(IOZONE_VERSION).tar
IOZONE_SITE = http://www.iozone.org/src/current
IOZONE_LICENSE = IOzone license (NO DERIVED WORKS ALLOWED)
# IOzone license details can be found at:
# http://www.iozone.org/docs/Iozone_License.txt

ifeq ($(BR2_TOOLCHAIN_BUILDROOT)$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC)$(BR2_TOOLCHAIN_CTNG_uClibc),y)
# aio.h is not available on uClibc. Select "generic" target that does not use it.
IOZONE_TARGET = generic
else ifeq ($(BR2_powerpc),y)
IOZONE_TARGET = linux-powerpc
else ifeq ($(BR2_sparc),y)
IOZONE_TARGET = linux-sparc
else
IOZONE_TARGET = linux
endif

define IOZONE_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(IOZONE_TARGET) -C $(@D)/src/current
endef

define IOZONE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/src/current/iozone \
		$(TARGET_DIR)/usr/bin/iozone
endef

define IOZONE_CLEAN_CMDS
       $(MAKE) -C $(@D)/src/current clean
endef

$(eval $(generic-package))
