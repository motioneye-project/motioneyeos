################################################################################
#
# edid-decode
#
################################################################################

EDID_DECODE_VERSION = f56f329ed23a25d002352dedba1e8f092a47286f
EDID_DECODE_SITE = git://linuxtv.org/edid-decode.git
EDID_DECODE_LICENSE = MIT
EDID_DECODE_LICENSE_FILES = edid-decode.c

define EDID_DECODE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"
endef

define EDID_DECODE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
