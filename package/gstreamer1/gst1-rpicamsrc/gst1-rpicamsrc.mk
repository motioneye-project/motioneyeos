################################################################################
#
# gst1-rpicamsrc
#
################################################################################

GST1_RPICAMSRC_VERSION = 4ee114fbbf35d85169603aa37678642e9774152a
GST1_RPICAMSRC_SITE = $(call github,thaytan,gst-rpicamsrc,$(GST1_RPICAMSRC_VERSION))

GST1_RPICAMSRC_LICENSE = LGPLv2.1
GST1_RPICAMSRC_LICENSE_FILES = COPYING

GST1_RPICAMSRC_POST_INSTALL_TARGET_HOOKS += GSTREAMER1_REMOVE_LA_FILES

GST1_RPICAMSRC_DEPENDENCIES = gstreamer1 gst1-plugins-base gst1-plugins-bad libopenmax

GST1_RPICAMSRC_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GL),y)
GST1_RPICAMSRC_DEPENDENCIES += gst1-plugins-bad
endif

GST1_RPICAMSRC_CONF_OPTS = --with-rpi-header-dir=$(STAGING_DIR)/usr/include

$(eval $(autotools-package))
