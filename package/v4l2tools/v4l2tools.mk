#############################################################
#
# v4l2tools
#
#############################################################

V4L2TOOLS_VERSION = ed0061a
V4L2TOOLS_SITE = https://github.com/jasaw/v4l2tools.git
V4L2TOOLS_SITE_METHOD = git
V4L2TOOLS_LICENSE = UNLICENSE
V4L2TOOLS_LICENSE_FILES = LICENSE
V4L2TOOLS_INSTALL_TARGET = YES
V4L2TOOLS_DEPENDENCIES = v4l2cpp
V4L2TOOLS_CFLAGS = $(TARGET_CFLAGS)

define V4L2TOOLS_REMOVE_MAKEFILE
	rm -f $(BUILD_DIR)/v4l2tools-$(V4L2TOOLS_VERSION)/Makefile
endef

V4L2TOOLS_PRE_PATCH_HOOKS += V4L2TOOLS_REMOVE_MAKEFILE

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
V4L2TOOLS_DEPENDENCIES += rpi-userland
V4L2TOOLS_MAKE_OPTS += HAVE_RPI=1
ifeq ($(BR2_PACKAGE_RPI_USERLAND_HELLO),y)
V4L2TOOLS_MAKE_OPTS += HAVE_RPI_IL=1
V4L2TOOLS_CFLAGS += -I$(STAGING_DIR)/usr/src/hello_pi/libs/ilclient
endif
endif # BR2_PACKAGE_RPI_USERLAND

ifeq ($(BR2_PACKAGE_LIBYUV),y)
V4L2TOOLS_DEPENDENCIES += libyuv
V4L2TOOLS_MAKE_OPTS += HAVE_LIBYUV=1

ifeq ($(BR2_PACKAGE_H264BITSTREAM),y)
# TODO: pull in h264bitstream from https://github.com/aizvorski/h264bitstream
#V4L2TOOLS_DEPENDENCIES += h264bitstream
#V4L2TOOLS_MAKE_OPTS += HAVE_H264BITSTREAM=1
endif

ifeq ($(BR2_PACKAGE_HEVCBITSTREAM),y)
# TODO: pull in hevcbitstream from https://github.com/leslie-wang/hevcbitstream
#V4L2TOOLS_DEPENDENCIES += hevcbitstream
#V4L2TOOLS_MAKE_OPTS += HAVE_HEVCBITSTREAM=1
endif

ifeq ($(BR2_PACKAGE_LIBVPX),y)
V4L2TOOLS_DEPENDENCIES += libvpx
V4L2TOOLS_MAKE_OPTS += HAVE_LIBVPX=1
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
V4L2TOOLS_DEPENDENCIES += jpeg
V4L2TOOLS_MAKE_OPTS += HAVE_LIBJPEG=1
endif
endif

ifeq ($(BR2_PACKAGE_LIBFUSE),y)
V4L2TOOLS_DEPENDENCIES += libfuse
V4L2TOOLS_MAKE_OPTS += HAVE_LIBFUSE=1
endif

ifndef ($(BR2_ENABLE_LOCALE),y)
V4L2TOOLS_CFLAGS += -DLOCALE_NOT_USED
endif

define V4L2TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" AR="$(TARGET_AR)" CFLAGS_EXTRA="$(V4L2TOOLS_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" ARFLAGS="$(TARGET_ARFLAGS)" PREFIX="$(STAGING_DIR)/usr" $(V4L2TOOLS_MAKE_OPTS) $(MAKE) -C $(@D) all
endef

define V4L2TOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/v4l2copy $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(@D)/v4l2source_yuv $(TARGET_DIR)/usr/sbin
	$(if $(BR2_PACKAGE_RPI_USERLAND_HELLO), $(INSTALL) -D -m 0755 $(@D)/v4l2grab_h264 $(TARGET_DIR)/usr/sbin )
	$(if $(BR2_PACKAGE_RPI_USERLAND_HELLO), $(INSTALL) -D -m 0755 $(@D)/v4l2display_h264 $(TARGET_DIR)/usr/sbin )
	$(if $(BR2_PACKAGE_RPI_USERLAND_HELLO), $(INSTALL) -D -m 0755 $(@D)/v4l2compress_omx $(TARGET_DIR)/usr/sbin )
	$(if $(BR2_PACKAGE_RPI_USERLAND), $(INSTALL) -D -m 0755 $(@D)/v4l2multi_stream_mmal $(TARGET_DIR)/usr/sbin )
	$(if $(BR2_PACKAGE_LIBYUV), $(INSTALL) -D -m 0755 $(@D)/v4l2convert_yuv $(TARGET_DIR)/usr/sbin )
	$(if $(and $(BR2_PACKAGE_LIBYUV),$(BR2_PACKAGE_H264BITSTREAM)), $(INSTALL) -D -m 0755 $(@D)/v4l2compress_h264 $(TARGET_DIR)/usr/sbin )
	$(if $(and $(BR2_PACKAGE_LIBYUV),$(BR2_PACKAGE_HEVCBITSTREAM)), $(INSTALL) -D -m 0755 $(@D)/v4l2compress_x265 $(TARGET_DIR)/usr/sbin )
	$(if $(and $(BR2_PACKAGE_LIBYUV),$(BR2_PACKAGE_H264BITSTREAM),$(BR2_PACKAGE_HEVCBITSTREAM)), $(INSTALL) -D -m 0755 $(@D)/v4l2dump $(TARGET_DIR)/usr/sbin )
	$(if $(and $(BR2_PACKAGE_LIBYUV),$(BR2_PACKAGE_VPX)), $(INSTALL) -D -m 0755 $(@D)/v4l2compress_vpx $(TARGET_DIR)/usr/sbin )
	$(if $(and $(BR2_PACKAGE_LIBYUV),$(BR2_PACKAGE_JPEG)), $(INSTALL) -D -m 0755 $(@D)/v4l2compress_jpeg $(TARGET_DIR)/usr/sbin )
	$(if $(and $(BR2_PACKAGE_LIBYUV),$(BR2_PACKAGE_JPEG)), $(INSTALL) -D -m 0755 $(@D)/v4l2uncompress_jpeg $(TARGET_DIR)/usr/sbin )
	$(if $(BR2_PACKAGE_LIBFUSE), $(INSTALL) -D -m 0755 $(@D)/v4l2fuse $(TARGET_DIR)/usr/sbin )
endef

$(eval $(generic-package))
