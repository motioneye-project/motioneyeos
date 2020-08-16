################################################################################
#
# libid3tag
#
################################################################################

LIBID3TAG_VERSION = 0.15.1b
LIBID3TAG_PATCH = libid3tag_$(LIBID3TAG_VERSION)-14.debian.tar.xz
LIBID3TAG_SOURCE = libid3tag_$(LIBID3TAG_VERSION).orig.tar.gz
LIBID3TAG_SITE = \
	http://snapshot.debian.org/archive/debian/20190310T213528Z/pool/main/libi/libid3tag
LIBID3TAG_LICENSE = GPL-2.0+
LIBID3TAG_LICENSE_FILES = COPYING COPYRIGHT
LIBID3TAG_INSTALL_STAGING = YES
LIBID3TAG_DEPENDENCIES = host-gperf zlib

# debian/patches/10_utf16.dpatch
LIBID3TAG_IGNORE_CVES += CVE-2004-2779 CVE-2017-11551

# debian/patches/11_unknown_encoding.dpatch
LIBID3TAG_IGNORE_CVES += CVE-2017-11550

# Force autoreconf to be able to use a more recent libtool script, that
# is able to properly behave in the face of a missing C++ compiler.
LIBID3TAG_AUTORECONF = YES

define LIBID3TAG_INSTALL_STAGING_PC
	$(INSTALL) -D package/libid3tag/id3tag.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/id3tag.pc
endef

LIBID3TAG_POST_INSTALL_STAGING_HOOKS += LIBID3TAG_INSTALL_STAGING_PC

$(eval $(autotools-package))
