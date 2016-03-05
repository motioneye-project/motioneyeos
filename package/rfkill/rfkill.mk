################################################################################
#
# rfkill
#
################################################################################

RFKILL_VERSION = 0.5
RFKILL_SOURCE = rfkill-$(RFKILL_VERSION).tar.xz
RFKILL_SITE = https://www.kernel.org/pub/software/network/rfkill
RFKILL_LICENSE = ISC
RFKILL_LICENSE_FILES = COPYING

define RFKILL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		VERSION_SUFFIX="br"
endef

define RFKILL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
