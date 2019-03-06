################################################################################
#
# xdriver_xf86-video-fbturbo
#
################################################################################

XDRIVER_XF86_VIDEO_FBTURBO_VERSION = 0.4.0
XDRIVER_XF86_VIDEO_FBTURBO_SITE = $(call github,ssvb,xf86-video-fbturbo,$(XDRIVER_XF86_VIDEO_FBTURBO_VERSION))
XDRIVER_XF86_VIDEO_FBTURBO_LICENSE = MIT
XDRIVER_XF86_VIDEO_FBTURBO_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_FBTURBO_DEPENDENCIES = \
	xserver_xorg-server \
	libdrm \
	pixman \
	xorgproto

ifeq ($(BR2_PACKAGE_LIBPCIACCESS),y)
XDRIVER_XF86_VIDEO_FBTURBO_DEPENDENCIES += libpciaccess
XDRIVER_XF86_VIDEO_FBTURBO_CONF_OPTS += --enable-pciaccess
else
XDRIVER_XF86_VIDEO_FBTURBO_CONF_OPTS += --disable-pciaccess
endif

define XDRIVER_XF86_VIDEO_FBTURBO_INSTALL_CONF_FILE
	$(INSTALL) -m 0644 -D $(@D)/xorg.conf $(TARGET_DIR)/etc/X11/xorg.conf
endef

XDRIVER_XF86_VIDEO_FBTURBO_POST_INSTALL_TARGET_HOOKS += XDRIVER_XF86_VIDEO_FBTURBO_INSTALL_CONF_FILE

$(eval $(autotools-package))
