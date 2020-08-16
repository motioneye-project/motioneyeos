################################################################################
#
# libmad
#
################################################################################

LIBMAD_VERSION = 0.15.1b
LIBMAD_PATCH = libmad_$(LIBMAD_VERSION)-10.diff.gz
LIBMAD_SOURCE = libmad_$(LIBMAD_VERSION).orig.tar.gz
LIBMAD_SITE = \
	http://snapshot.debian.org/archive/debian/20190310T213528Z/pool/main/libm/libmad
LIBMAD_INSTALL_STAGING = YES
LIBMAD_LICENSE = GPL-2.0+
LIBMAD_LICENSE_FILES = COPYING

define LIBMAD_APPLY_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		$(APPLY_PATCHES) $(@D) $(@D)/debian/patches *.patch; \
	fi
endef

LIBMAD_POST_PATCH_HOOKS += LIBMAD_APPLY_DEBIAN_PATCHES

# debian/patches/md_size.diff
LIBMAD_IGNORE_CVES += CVE-2017-8372 CVE-2017-8373

# debian/patches/length-check.patch
LIBMAD_IGNORE_CVES += CVE-2017-8374

# Force autoreconf to be able to use a more recent libtool script, that
# is able to properly behave in the face of a missing C++ compiler.
LIBMAD_AUTORECONF = YES

define LIBMAD_INSTALL_STAGING_PC
	$(INSTALL) -D package/libmad/mad.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/mad.pc
endef

LIBMAD_POST_INSTALL_STAGING_HOOKS += LIBMAD_INSTALL_STAGING_PC

LIBMAD_CONF_OPTS = \
	--disable-debugging \
	$(if $(BR2_PACKAGE_LIBMAD_OPTIMIZATION_SPEED),--enable-speed) \
	$(if $(BR2_PACKAGE_LIBMAD_OPTIMIZATION_ACCURACY),--enable-accuracy) \
	--$(if $(BR2_PACKAGE_LIBMAD_SSO),enable,disable)-sso \
	--$(if $(BR2_PACKAGE_LIBMAD_ASO),enable,disable)-aso \
	--$(if $(BR2_PACKAGE_LIBMAD_STRICT_ISO),enable,disable)-strict-iso

$(eval $(autotools-package))
