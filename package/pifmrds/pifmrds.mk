################################################################################
#
# pifmrds
#
################################################################################

PIFMRDS_VERSION = c67306ea9b8d827f45e0d90279d367e97119bcb1
PIFMRDS_SITE = $(call github,ChristopheJacquet,PiFmRds,$(PIFMRDS_VERSION))
PIFMRDS_DEPENDENCIES = libsndfile
PIFMRDS_LICENSE = GPLv3+
PIFMRDS_LICENSE_FILES = LICENSE

define PIFMRDS_BUILD_CMDS
	$(MAKE) -C $(@D)/src CC="$(TARGET_CC)" LDFLAGS="$(TARGET_LDFLAGS)" \
		CFLAGS="$(TARGET_CFLAGS) -std=gnu99 -ffast-math -c" \
		app rds_wav
endef

define PIFMRDS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/pi_fm_rds $(TARGET_DIR)/usr/bin/pi_fm_rds
	$(INSTALL) -D -m 0755 $(@D)/src/rds_wav $(TARGET_DIR)/usr/bin/rds_wav
endef

$(eval $(generic-package))
