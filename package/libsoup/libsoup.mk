#############################################################
#
# libsoup
#
#############################################################

LIBSOUP_MAJOR_VERSION:=2.31
LIBSOUP_VERSION:=$(LIBSOUP_MAJOR_VERSION).2
LIBSOUP_SOURCE:=libsoup-$(LIBSOUP_VERSION).tar.bz2
LIBSOUP_SITE:=http://ftp.gnome.org/pub/gnome/sources/libsoup/$(LIBSOUP_MAJOR_VERSION)
LIBSOUP_INSTALL_STAGING = YES

LIBSOUP_CONF_ENV = ac_cv_path_GLIB_GENMARSHAL=$(LIBGLIB2_HOST_BINARY)

ifneq ($(BR2_INET_IPV6),y)
LIBSOUP_CONF_ENV += soup_cv_ipv6=no
endif

LIBSOUP_CONF_OPT = \
	--enable-shared		\
	--enable-static		\
	--disable-explicit-deps \
	--disable-glibtest	\
	--disable-ssl		\
	--without-gnome

LIBSOUP_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl) host-pkg-config host-libglib2 libglib2 libxml2

$(eval $(call AUTOTARGETS,package,libsoup))
