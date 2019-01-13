################################################################################
#
# iozone
#
################################################################################

IOZONE_VERSION = 3_483
IOZONE_SOURCE = iozone$(IOZONE_VERSION).tar
IOZONE_SITE = http://www.iozone.org/src/current
IOZONE_LICENSE = IOzone license (NO DERIVED WORKS ALLOWED)
# IOzone license details can be found at:
# http://www.iozone.org/docs/Iozone_License.txt

# AIO support not available on uClibc, use the linux (non-aio) target.
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
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

$(eval $(generic-package))
