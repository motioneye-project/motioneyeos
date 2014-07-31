################################################################################
#
# libvorbis
#
################################################################################

LIBVORBIS_VERSION = 1.3.4
LIBVORBIS_SOURCE = libvorbis-$(LIBVORBIS_VERSION).tar.xz
LIBVORBIS_SITE = http://downloads.xiph.org/releases/vorbis
LIBVORBIS_INSTALL_STAGING = YES
LIBVORBIS_CONF_OPT = --disable-oggtest
LIBVORBIS_DEPENDENCIES = host-pkgconf libogg
LIBVORBIS_LICENSE = BSD-3c
LIBVORBIS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
