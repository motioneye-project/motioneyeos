################################################################################
#
# libmad
#
################################################################################

LIBMAD_VERSION = 0.15.1b
LIBMAD_SITE = http://downloads.sourceforge.net/project/mad/libmad/$(LIBMAD_VERSION)
LIBMAD_INSTALL_STAGING = YES
LIBMAD_LIBTOOL_PATCH = NO
LIBMAD_LICENSE = GPL-2.0+
LIBMAD_LICENSE_FILES = COPYING
LIBMAD_PATCH = \
	https://sources.debian.net/data/main/libm/libmad/0.15.1b-8/debian/patches/frame_length.diff

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
