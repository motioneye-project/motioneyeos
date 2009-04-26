#############################################################
#
# libsoup
#
#############################################################

LIBSOUP_VERSION:=2.4.1
LIBSOUP_SOURCE:=libsoup-$(LIBSOUP_VERSION).tar.gz
LIBSOUP_SITE:=http://ftp.gnome.org/pub/gnome/sources/libsoup/2.4
LIBSOUP_AUTORECONF = NO
LIBSOUP_INSTALL_STAGING = YES
LIBSOUP_INSTALL_TARGET = YES

LIBSOUP_CONF_ENV = \
		ac_cv_path_GLIB_GENMARSHAL=$(HOST_GLIB)/bin/glib-genmarshal

ifneq ($(BR2_INET_IPV6),y)
LIBSOUP_CONF_ENV += soup_cv_ipv6=no
endif

LIBSOUP_CONF_OPT = \
	--enable-shared		\
	--enable-static		\
	--disable-explicit-deps \
	--disable-glibtest	\
	--disable-gtk-doc --without-html-dir

LIBSOUP_DEPENDENCIES = uclibc gettext libintl host-pkgconfig host-libglib2 libglib2 libxml2

$(eval $(call AUTOTARGETS,package,libsoup))
