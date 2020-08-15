################################################################################
#
# libvorbis
#
################################################################################

LIBVORBIS_VERSION = 1.3.6
LIBVORBIS_SOURCE = libvorbis-$(LIBVORBIS_VERSION).tar.xz
LIBVORBIS_SITE = http://downloads.xiph.org/releases/vorbis
LIBVORBIS_INSTALL_STAGING = YES
LIBVORBIS_CONF_OPTS = --disable-oggtest
LIBVORBIS_DEPENDENCIES = host-pkgconf libogg
LIBVORBIS_LICENSE = BSD-3-Clause
LIBVORBIS_LICENSE_FILES = COPYING

# 0001-CVE-2017-14160-fix-bounds-check-on-very-low-sample-rates.patch
LIBVORBIS_IGNORE_CVES += CVE-2018-10393

# 0002-Sanity-check-number-of-channels-in-setup.patch
LIBVORBIS_IGNORE_CVES += CVE-2018-10392

$(eval $(autotools-package))
