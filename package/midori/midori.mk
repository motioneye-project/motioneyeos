################################################################################
#
# midori
#
################################################################################

MIDORI_VERSION = 0.5.11
MIDORI_SOURCE = midori_$(MIDORI_VERSION)_all_.tar.bz2
MIDORI_SITE = http://midori-browser.org/downloads
MIDORI_LICENSE = LGPL-2.1+
MIDORI_LICENSE_FILES = COPYING
MIDORI_DEPENDENCIES = \
	host-intltool \
	host-librsvg \
	host-pkgconf \
	host-vala \
	host-python \
	$(if $(BR2_PACKAGE_LIBGTK3_X11),gcr) \
	granite \
	libgtk3 \
	libsoup \
	libxml2 \
	sqlite \
	webkitgtk \
	$(TARGET_NLS_DEPENDENCIES) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)

MIDORI_CONF_OPTS = \
	-DHALF_BRO_INCOM_WEBKIT2=ON \
	-DUSE_GRANITE=ON \
	-DUSE_GTK3=ON \
	-DUSE_ZEITGEIST=OFF

$(eval $(cmake-package))
