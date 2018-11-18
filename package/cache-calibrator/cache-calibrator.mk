################################################################################
#
# cache-calibrator
#
################################################################################

CACHE_CALIBRATOR_SOURCE = calibrator.c
CACHE_CALIBRATOR_SITE = http://homepages.cwi.nl/~manegold/Calibrator/src
CACHE_CALIBRATOR_LICENSE = Cache calibrator license
CACHE_CALIBRATOR_LICENSE_FILES = calibrator.c.license

define CACHE_CALIBRATOR_EXTRACT_CMDS
	cp $(CACHE_CALIBRATOR_DL_DIR)/$(CACHE_CALIBRATOR_SOURCE) $(@D)
endef

define CACHE_CALIBRATOR_EXTRACT_LICENSE
	head -n 38 $(@D)/calibrator.c >$(@D)/calibrator.c.license
endef
CACHE_CALIBRATOR_PRE_PATCH_HOOKS += CACHE_CALIBRATOR_EXTRACT_LICENSE

define CACHE_CALIBRATOR_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(@D)/calibrator.c -o $(@D)/cache_calibrator -lm
endef

define CACHE_CALIBRATOR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/cache_calibrator $(TARGET_DIR)/usr/bin/cache_calibrator
endef

$(eval $(generic-package))
