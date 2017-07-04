################################################################################
#
# gst-omx
#
################################################################################

GST_OMX_VERSION = 1.12.1
GST_OMX_SOURCE = gst-omx-$(GST_OMX_VERSION).tar.xz
GST_OMX_SITE = https://gstreamer.freedesktop.org/src/gst-omx

GST_OMX_LICENSE = LGPL-2.1
GST_OMX_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
GST_OMX_CONF_OPTS = \
	--with-omx-target=rpi
GST_OMX_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) \
		-I$(STAGING_DIR)/usr/include/IL \
		-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads \
		-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux"
endif

ifeq ($(BR2_PACKAGE_BELLAGIO),y)
GST_OMX_CONF_OPTS = \
	--with-omx-target=bellagio
GST_OMX_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) \
		-DOMX_VERSION_MAJOR=1 \
		-DOMX_VERSION_MINOR=1 \
		-DOMX_VERSION_REVISION=2 \
		-DOMX_VERSION_STEP=0"
endif

GST_OMX_DEPENDENCIES = gstreamer1 gst1-plugins-base libopenmax

# adjust library paths to where buildroot installs them
define GST_OMX_FIXUP_CONFIG_PATHS
	find $(@D)/config -name gstomx.conf | \
		xargs $(SED) 's|/usr/local|/usr|g' -e 's|/opt/vc|/usr|g'
endef

GST_OMX_POST_PATCH_HOOKS += GST_OMX_FIXUP_CONFIG_PATHS

$(eval $(autotools-package))
