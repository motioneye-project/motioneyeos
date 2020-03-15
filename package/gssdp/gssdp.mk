################################################################################
#
# gssdp
#
################################################################################

GSSDP_VERSION_MAJOR = 1.0
GSSDP_VERSION = $(GSSDP_VERSION_MAJOR).3
GSSDP_SOURCE = gssdp-$(GSSDP_VERSION).tar.xz
GSSDP_SITE = http://ftp.gnome.org/pub/gnome/sources/gssdp/$(GSSDP_VERSION_MAJOR)
GSSDP_LICENSE = LGPL-2.0+
GSSDP_LICENSE_FILES = COPYING
GSSDP_INSTALL_STAGING = YES
GSSDP_DEPENDENCIES = host-pkgconf libglib2 libsoup
GSSDP_CONF_OPTS = \
	-Dexamples=false \
	-Dvapi=false

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
GSSDP_CONF_OPTS += -Dintrospection=true
GSSDP_DEPENDENCIES += gobject-introspection
else
GSSDP_CONF_OPTS += -Dintrospection=false
endif

ifeq ($(BR2_PACKAGE_LIBGTK3),y)
GSSDP_DEPENDENCIES += libgtk3
GSSDP_CONF_OPTS += -Dsniffer=true
else
GSSDP_CONF_OPTS += -Dsniffer=false
endif

$(eval $(meson-package))
