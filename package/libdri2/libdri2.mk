################################################################################
#
# libdri2
#
################################################################################

LIBDRI2_VERSION = 4f1eef3183df2b270c3d5cbef07343ee5127a6a4
LIBDRI2_SITE = $(call github,robclark,libdri2,$(LIBDRI2_VERSION))
LIBDRI2_DEPENDENCIES = xlib_libXext xproto_dri2proto xlib_libXdamage libdrm
LIBDRI2_LICENSE = MIT
LIBDRI2_LICENSE_FILES = COPYING

LIBDRI2_INSTALL_STAGING = YES
LIBDRI2_AUTORECONF = YES
LIBDRI2_CONF_ENV = xorg_cv_malloc0_returns_null=true

$(eval $(autotools-package))
