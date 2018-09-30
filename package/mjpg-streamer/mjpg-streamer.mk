################################################################################
#
# mjpg-streamer
#
################################################################################

MJPG_STREAMER_VERSION = f387bb44e6c087271b763b27da998bf2e06c4f5d
MJPG_STREAMER_SITE = $(call github,jacksonliam,mjpg-streamer,$(MJPG_STREAMER_VERSION))
MJPG_STREAMER_SUBDIR = mjpg-streamer-experimental
MJPG_STREAMER_LICENSE = GPL-2.0+
MJPG_STREAMER_LICENSE_FILES = $(MJPG_STREAMER_SUBDIR)/LICENSE
MJPG_STREAMER_DEPENDENCIES = jpeg

ifeq ($(BR2_PACKAGE_LIBV4L),y)
MJPG_STREAMER_DEPENDENCIES += libv4l
endif

ifeq ($(BR2_PACKAGE_OPENCV3_LIB_IMGPROC)$(BR2_PACKAGE_OPENCV3_LIB_IMGPROC)$(BR2_PACKAGE_OPENCV3_LIB_IMGPROC),yyy)
MJPG_STREAMER_CONF_OPTS += -DPLUGIN_INPUT_OPENCV=ON
MJPG_STREAMER_DEPENDENCIES += host-pkgconf opencv3
else
MJPG_STREAMER_CONF_OPTS += -DPLUGIN_INPUT_OPENCV=OFF
endif

$(eval $(cmake-package))
