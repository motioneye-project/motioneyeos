################################################################################
#
# cog
#
################################################################################

COG_VERSION = 0.6.0
COG_SITE = https://wpewebkit.org/releases
COG_SOURCE = cog-$(COG_VERSION).tar.xz
COG_INSTALL_STAGING = YES
COG_DEPENDENCIES = dbus wpewebkit wpebackend-fdo wayland
COG_LICENSE = MIT
COG_LICENSE_FILES = COPYING
COG_CONF_OPTS = \
	-DCOG_BUILD_PROGRAMS=ON \
	-DCOG_WESTON_DIRECT_DISPLAY=OFF \
	-DINSTALL_MAN_PAGES=OFF \
	-DCOG_HOME_URI='$(call qstrip,$(BR2_PACKAGE_COG_PROGRAMS_HOME_URI))'

ifeq ($(BR2_PACKAGE_COG_PLATFORM_FDO),y)
COG_CONF_OPTS += -DCOG_PLATFORM_FDO=ON
COG_DEPENDENCIES += libxkbcommon wayland-protocols
else
COG_CONF_OPTS += -DCOG_PLATFORM_FDO=OFF
endif

ifeq ($(BR2_PACKAGE_COG_PLATFORM_DRM),y)
COG_CONF_OPTS += -DCOG_PLATFORM_DRM=ON
COG_DEPENDENCIES += libdrm libinput
else
COG_CONF_OPTS += -DCOG_PLATFORM_DRM=OFF
endif

$(eval $(cmake-package))
