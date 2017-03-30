################################################################################
#
# pifmrds
#
################################################################################

PIFMRDS_VERSION = 0bf57f9ce0d954365a38d8af8e7be6f28521c3f2
PIFMRDS_SITE = $(call github,ChristopheJacquet,PiFmRds,$(PIFMRDS_VERSION))
PIFMRDS_DEPENDENCIES = libsndfile
PIFMRDS_LICENSE = GPL-3.0+
PIFMRDS_LICENSE_FILES = LICENSE

define PIFMRDS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src CC="$(TARGET_CC)" LDFLAGS="$(TARGET_LDFLAGS)" \
		CFLAGS="$(TARGET_CFLAGS) -std=gnu99 -ffast-math -c" \
		app rds_wav
endef

define PIFMRDS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/pi_fm_rds $(TARGET_DIR)/usr/bin/pi_fm_rds
	$(INSTALL) -D -m 0755 $(@D)/src/rds_wav $(TARGET_DIR)/usr/bin/rds_wav
endef

$(eval $(generic-package))
