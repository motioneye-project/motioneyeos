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
MJPG_STREAMER_LICENSE = GPL-2.0+
MJPG_STREAMER_LICENSE_FILES = LICENSE
MJPG_STREAMER_DEPENDENCIES = jpeg

ifeq ($(BR2_PACKAGE_LIBV4L),y)
MJPG_STREAMER_DEPENDENCIES += libv4l
MJPG_STREAMER_USE_LIBV4L += USE_LIBV4L2=true
endif

define MJPG_STREAMER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" -C $(@D) $(MJPG_STREAMER_USE_LIBV4L)
endef

define MJPG_STREAMER_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
