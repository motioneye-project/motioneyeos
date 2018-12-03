################################################################################
#
# atk
#
################################################################################

ATK_VERSION_MAJOR = 2.30
ATK_VERSION = $(ATK_VERSION_MAJOR).0
ATK_SOURCE = atk-$(ATK_VERSION).tar.xz
ATK_SITE = http://ftp.gnome.org/pub/gnome/sources/atk/$(ATK_VERSION_MAJOR)
ATK_LICENSE = LGPL-2.0+
ATK_LICENSE_FILES = COPYING
ATK_INSTALL_STAGING = YES
ATK_DEPENDENCIES = libglib2

$(eval $(meson-package))
