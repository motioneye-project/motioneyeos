################################################################################
#
# gst-fsl-plugins
#
################################################################################

GST_FSL_PLUGINS_VERSION = 3.0.1
# No official download site from freescale, just this mirror
GST_FSL_PLUGINS_SITE = http://download.ossystems.com.br/bsp/freescale/source

# Most is LGPLv2+, but some sources are copied from upstream and are
# LGPLv2.1+, which essentially makes it LGPLv2.1+
GST_FSL_PLUGINS_LICENSE = LGPLv2+, LGPLv2.1+, PROPRIETARY (asf.h)
GST_FSL_PLUGINS_LICENSE_FILES = COPYING-LGPL-2.1 COPYING-LGPL-2

GST_FSL_PLUGINS_INSTALL_STAGING = YES
GST_FSL_PLUGINS_AUTORECONF = YES

GST_FSL_PLUGINS_DEPENDENCIES += host-pkgconf gstreamer gst-plugins-base \
	libfslvpuwrap imx-lib libfslparser libfslcodec

GST_FSL_PLUGINS_CONF_ENV = PLATFORM=$(BR2_PACKAGE_GST_FSL_PLUGINS_PLATFORM)

# needs access to imx-specific kernel headers
GST_FSL_PLUGINS_DEPENDENCIES += linux
GST_FSL_PLUGINS_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -idirafter $(LINUX_DIR)/include"

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
GST_FSL_PLUGINS_DEPENDENCIES += xlib_libX11
GST_FSL_PLUGINS_CONF_OPT += --enable-x11
else
GST_FSL_PLUGINS_CONF_OPT += --disable-x11
endif

# Autoreconf requires an m4 directory to exist
define GST_FSL_PLUGINS_PATCH_M4
	mkdir -p $(@D)/m4
endef

GST_FSL_PLUGINS_POST_PATCH_HOOKS += GST_FSL_PLUGINS_PATCH_M4

$(eval $(autotools-package))
