#############################################################
#
# libupnp
#
#############################################################
LIBUPNP_VERSION:=1.6.6
LIBUPNP_SOURCE:=libupnp-$(LIBUPNP_VERSION).tar.bz2
LIBUPNP_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/pupnp

LIBUPNP_INSTALL_STAGING:=YES
LIBUPNP_INSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) install-strip

$(eval $(call AUTOTARGETS,package,libupnp))
