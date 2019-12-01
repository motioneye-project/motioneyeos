################################################################################
#
# semver-sort
#
################################################################################

SEMVER_SORT_VERSION = 7cf3c5c783aeea6c2b8673c92b76cc51a1ec7ad5
SEMVER_SORT_SITE = $(call github,ccrisan,semver-sort,$(SEMVER_SORT_VERSION))
SEMVER_SORT_LICENSE = MIT

define SEMVER_SORT_BUILD_CMDS
    make CC="$(TARGET_CC)" -C "$(@D)" semver-sort
endef

define SEMVER_SORT_INSTALL_TARGET_CMDS
    cp $(@D)/semver-sort $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
