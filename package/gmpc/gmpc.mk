#############################################################
#
# gmpc
#
#############################################################

GMPC_VERSION = 11.8.16
GMPC_SITE = http://download.sarine.nl/Programs/gmpc/$(GMPC_VERSION)
GMPC_CONF_ENV = ac_cv_path_GOB2=$(GOB2_HOST_BINARY)
GMPC_CONF_OPT = --disable-mmkeys --disable-unique
GMPC_DEPENDENCIES = host-gob2 host-intltool host-pkg-config host-vala \
	libglib2 libgtk2 libmpd libsoup sqlite \
	xlib_libICE xlib_libSM xlib_libX11 \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)

$(eval $(autotools-package))
