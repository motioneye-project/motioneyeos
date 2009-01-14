#############################################################
#
# libupnp
#
#############################################################
LIBUPNP_VERSION:=1.6.6
LIBUPNP_SOURCE:=libupnp-$(LIBUPNP_VERSION).tar.bz2
LIBUPNP_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/pupnp

LIBUPNP_CONF_ENV = ac_cv_lib_compat_ftime=no

LIBUPNP_INSTALL_STAGING:=YES

$(eval $(call AUTOTARGETS,package,libupnp))
