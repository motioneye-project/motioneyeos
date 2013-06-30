################################################################################
#
# iozone
#
################################################################################

IOZONE_VERSION = 3_414
IOZONE_SOURCE = iozone$(IOZONE_VERSION).tar
IOZONE_SITE = http://www.iozone.org/src/current
IOZONE_LICENSE = IOzone license (NO DERIVED WORKS ALLOWED)
# IOzone license details can be found at:
# http://www.iozone.org/docs/Iozone_License.txt

# No threading target is non-AIO as well
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
IOZONE_TARGET = linux-noth
# AIO support not available on uClibc, use the linux (non-aio) target.
else ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
IOZONE_TARGET = linux-noaio
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
