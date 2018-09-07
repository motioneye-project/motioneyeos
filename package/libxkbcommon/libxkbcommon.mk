################################################################################
#
# libxkbcommon
#
################################################################################

LIBXKBCOMMON_VERSION = 0.8.2
LIBXKBCOMMON_SITE = http://xkbcommon.org/download
LIBXKBCOMMON_SOURCE = libxkbcommon-$(LIBXKBCOMMON_VERSION).tar.xz
LIBXKBCOMMON_LICENSE = MIT/X11
LIBXKBCOMMON_LICENSE_FILES = LICENSE
LIBXKBCOMMON_INSTALL_STAGING = YES
LIBXKBCOMMON_DEPENDENCIES = host-bison host-flex
LIBXKBCOMMON_CONF_OPTS = --disable-wayland
# uses C99 features
LIBXKBCOMMON_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -std=gnu99"

ifeq ($(BR2_PACKAGE_XORG7),y)
LIBXKBCOMMON_CONF_OPTS += --enable-x11
LIBXKBCOMMON_DEPENDENCIES += libxcb
else
LIBXKBCOMMON_CONF_OPTS += --disable-x11
endif

$(eval $(autotools-package))
