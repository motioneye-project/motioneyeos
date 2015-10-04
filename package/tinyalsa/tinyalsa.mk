################################################################################
#
# tinyalsa
#
################################################################################

TINYALSA_VERSION = f2a7b6d3d81bd337a540d56704b4aaa7bdb046fe
TINYALSA_SITE = $(call github,tinyalsa,tinyalsa,$(TINYALSA_VERSION))
TINYALSA_LICENSE = BSD-3c
TINYALSA_INSTALL_STAGING = YES

define TINYALSA_BUILD_CMDS
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D)
endef

define TINYALSA_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libtinyalsa.so \
		$(STAGING_DIR)/usr/lib/libtinyalsa.so
	$(INSTALL) -D -m 0644 $(@D)/include/tinyalsa/asoundlib.h \
		$(STAGING_DIR)/usr/include/tinyalsa/asoundlib.h
endef

define TINYALSA_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libtinyalsa.so \
		$(TARGET_DIR)/usr/lib/libtinyalsa.so
	$(INSTALL) -D -m 0755 $(@D)/tinyplay $(TARGET_DIR)/usr/bin/tinyplay
	$(INSTALL) -D -m 0755 $(@D)/tinycap $(TARGET_DIR)/usr/bin/tinycap
	$(INSTALL) -D -m 0755 $(@D)/tinymix $(TARGET_DIR)/usr/bin/tinymix
	$(INSTALL) -D -m 0755 $(@D)/tinypcminfo $(TARGET_DIR)/usr/bin/tinypcminfo
endef

$(eval $(generic-package))
