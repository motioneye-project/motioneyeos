################################################################################
#
# libexif
#
################################################################################

LIBEXIF_VERSION = 0.6.21
LIBEXIF_SOURCE = libexif-$(LIBEXIF_VERSION).tar.bz2
LIBEXIF_SITE = http://downloads.sourceforge.net/project/libexif/libexif/$(LIBEXIF_VERSION)
LIBEXIF_INSTALL_STAGING = YES
LIBEXIF_DEPENDENCIES = host-pkgconf
LIBEXIF_LICENSE = LGPL-2.1+
LIBEXIF_LICENSE_FILES = COPYING

# 0001-fixes-some-not-all-buffer-overreads-during-decoding-.patch
LIBEXIF_IGNORE_CVES += CVE-2016-6328
# 0002-On-saving-makernotes-make-sure-the-makernote-contain.patch
LIBEXIF_IGNORE_CVES += CVE-2017-7544
# 0004-Improve-deep-recursion-detection-in-exif_data_load_d.patch
LIBEXIF_IGNORE_CVES += CVE-2018-20030
# 0005-fix-CVE-2019-9278.patch
LIBEXIF_IGNORE_CVES += CVE-2019-9278

$(eval $(autotools-package))
