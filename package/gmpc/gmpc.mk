#############################################################
#
# gmpc
#
#############################################################
GMPC_VERSION = 0.17.0
GMPC_SOURCE = gmpc-$(GMPC_VERSION).tar.gz
GMPC_SITE = http://download.sarine.nl/download/Programs/gmpc/$(GMPC_VERSION)/
GMPC_CONF_ENV = ac_cv_lib_curl_curl_global_init=yes \
		ac_cv_path_GOB2=$(GOB2_HOST_BINARY)
GMPC_CONF_OPT = --disable-mmkeys

GMPC_DEPENDENCIES = libglib2 libgtk2 libglade libcurl libmpd host-gob2 host-intltool \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)

ifeq ($(BR2_PACKAGE_XLIB_LIBSM),y)
GMPC_DEPENDENCIES += xlib_libSM
GMPC_CONF_OPT += --enable-sm
else
GMPC_CONF_OPT += --disable-sm
endif

$(eval $(call AUTOTARGETS,package,gmpc))
