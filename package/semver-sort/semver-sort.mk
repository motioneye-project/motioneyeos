################################################################################
#
# semver-sort
#
################################################################################

SEMVER_SORT_VERSION = a4de79b7691945e1db9b21ffc5b39b751477dc4e
SEMVER_SORT_SITE = $(call github,ccrisan,semver-sort,$(SEMVER_SORT_VERSION))
SEMVER_SORT_LICENSE = MIT

define SEMVER_SORT_BUILD_CMDS
    make CC="$(TARGET_CC)" -C "$(@D)" semver-sort
endef

define SEMVER_SORT_INSTALL_TARGET_CMDS
    cp $(@D)/semver-sort $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
