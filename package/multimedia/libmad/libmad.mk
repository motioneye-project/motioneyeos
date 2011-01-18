#############################################################
#
# libmad
#
#############################################################

LIBMAD_VERSION = 0.15.1b
LIBMAD_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mad/
LIBMAD_INSTALL_STAGING = YES
LIBMAD_LIBTOOL_PATCH = NO

define LIBMAD_PREVENT_AUTOMAKE
	# Prevent automake from running.
	(cd $(@D); touch -c config* aclocal.m4 Makefile*);
endef

define LIBMAD_INSTALL_STAGING_PC
	$(INSTALL) -D package/multimedia/libmad/mad.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/mad.pc
endef

define LIBMAD_INSTALL_TARGET_PC
	$(INSTALL) -D package/multimedia/libmad/mad.pc \
		$(TARGET_DIR)/usr/lib/pkgconfig/mad.pc
endef

LIBMAD_POST_PATCH_HOOKS += LIBMAD_PREVENT_AUTOMAKE
LIBMAD_POST_INSTALL_STAGING_HOOKS += LIBMAD_INSTALL_STAGING_PC
LIBMAD_POST_INSTALL_TARGET_HOOKS += LIBMAD_INSTALL_TARGET_PC

LIBMAD_CONF_OPT = \
		--disable-debugging \
		--enable-speed

$(eval $(call AUTOTARGETS,package/multimedia,libmad))
