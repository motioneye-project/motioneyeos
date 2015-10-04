################################################################################
#
# libmad
#
################################################################################

LIBMAD_VERSION = 0.15.1b
LIBMAD_SITE = http://downloads.sourceforge.net/project/mad/libmad/$(LIBMAD_VERSION)
LIBMAD_INSTALL_STAGING = YES
LIBMAD_LIBTOOL_PATCH = NO
LIBMAD_LICENSE = GPLv2+
LIBMAD_LICENSE_FILES = COPYING

define LIBMAD_PREVENT_AUTOMAKE
	# Prevent automake from running.
	(cd $(@D); touch -c config* aclocal.m4 Makefile*);
endef

define LIBMAD_INSTALL_STAGING_PC
	$(INSTALL) -D package/libmad/mad.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/mad.pc
endef

define LIBMAD_INSTALL_TARGET_PC
	$(INSTALL) -D package/libmad/mad.pc \
		$(TARGET_DIR)/usr/lib/pkgconfig/mad.pc
endef

LIBMAD_POST_PATCH_HOOKS += LIBMAD_PREVENT_AUTOMAKE
LIBMAD_POST_INSTALL_STAGING_HOOKS += LIBMAD_INSTALL_STAGING_PC
LIBMAD_POST_INSTALL_TARGET_HOOKS += LIBMAD_INSTALL_TARGET_PC

LIBMAD_CONF_OPTS = \
	--disable-debugging \
	$(if $(BR2_PACKAGE_LIBMAD_OPTIMIZATION_SPEED),--enable-speed) \
	$(if $(BR2_PACKAGE_LIBMAD_OPTIMIZATION_ACCURACY),--enable-accuracy) \
	--$(if $(BR2_PACKAGE_LIBMAD_SSO),enable,disable)-sso \
	--$(if $(BR2_PACKAGE_LIBMAD_ASO),enable,disable)-aso \
	--$(if $(BR2_PACKAGE_LIBMAD_STRICT_ISO),enable,disable)-strict-iso

$(eval $(autotools-package))
