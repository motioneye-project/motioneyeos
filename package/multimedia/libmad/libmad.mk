#############################################################
#
# libmad
#
#############################################################

LIBMAD_VERSION=0.15.1b
LIBMAD_SOURCE=libmad-$(LIBMAD_VERSION).tar.gz
LIBMAD_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mad/
LIBMAD_INSTALL_STAGING=YES
LIBMAD_LIBTOOL_PATCH=NO

define LIBMAD_PREVENT_AUTOMAKE
	# Prevent automake from running.
	(cd $(@D); touch -c config* aclocal.m4 Makefile*);
endef

LIBMAD_POST_PATCH_HOOKS += LIBMAD_PREVENT_AUTOMAKE

LIBMAD_CONF_OPT = \
		--disable-debugging \
		--enable-speed

$(eval $(call AUTOTARGETS,package/multimedia,libmad))
