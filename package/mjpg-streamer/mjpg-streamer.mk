################################################################################
#
# mjpg-streamer
#
################################################################################

# Original source is located at
# http://sourceforge.net/p/mjpg-streamer/code/commit_browser
# oliv3r forked the repo to add support for 3.16 and 3.17 kernels:
# http://sourceforge.net/p/mjpg-streamer/patches/14/
MJPG_STREAMER_VERSION = bbf32fddfd02a9e072e89e83a5b33e6ca0a7bd4b
MJPG_STREAMER_SITE = $(call github,oliv3r,mjpg-streamer,$(MJPG_STREAMER_VERSION))
MJPG_STREAMER_LICENSE = GPLv2+
MJPG_STREAMER_LICENSE_FILES = LICENSE
MJPG_STREAMER_DEPENDENCIES = jpeg

define MJPG_STREAMER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" -C $(@D)
endef

define MJPG_STREAMER_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
