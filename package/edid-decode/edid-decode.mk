################################################################################
#
# edid-decode
#
################################################################################

EDID_DECODE_VERSION = 681153145d5e05ee15032ea792e967cda06e7622
EDID_DECODE_SITE = git://anongit.freedesktop.org/git/xorg/app/edid-decode.git
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
