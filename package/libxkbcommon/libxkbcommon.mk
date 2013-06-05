################################################################################
#
# libxkbcommon
#
################################################################################

LIBXKBCOMMON_VERSION = 0.3.0
LIBXKBCOMMON_SITE = http://xkbcommon.org/download/
LIBXKBCOMMON_SOURCE = libxkbcommon-$(LIBXKBCOMMON_VERSION).tar.xz
LIBXKBCOMMON_LICENSE = MIT/X11
LIBXKBCOMMON_LICENSE_FILES = COPYING

LIBXKBCOMMON_INSTALL_STAGING = YES
LIBXKBCOMMON_DEPENDENCIES = host-bison host-flex
# uses C99 features
LIBXKBCOMMON_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -std=gnu99"

$(eval $(autotools-package))
