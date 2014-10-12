################################################################################
#
# snowball-hdmiservice
#
################################################################################

SNOWBALL_HDMISERVICE_VERSION = f75c99d1c52707240a78b4ba78e41d20d3aa3b08
SNOWBALL_HDMISERVICE_SITE = $(call github,igloocommunity,hdmiservice,$(SNOWBALL_HDMISERVICE_VERSION))
SNOWBALL_HDMISERVICE_LICENSE = MIT
SNOWBALL_HDMISERVICE_LICENSE_FILES = debian/copyright
SNOWBALL_HDMISERVICE_INSTALL_STAGING = YES

define SNOWBALL_HDMISERVICE_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC) $(TARGET_CFLAGS)"
endef

define SNOWBALL_HDMISERVICE_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC) $(TARGET_CFLAGS)" DESTDIR=$(STAGING_DIR) install
endef

define SNOWBALL_HDMISERVICE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC) $(TARGET_CFLAGS)" DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
