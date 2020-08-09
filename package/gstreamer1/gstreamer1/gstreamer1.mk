################################################################################
#
# gstreamer1
#
################################################################################

GSTREAMER1_VERSION = 1.16.2
GSTREAMER1_SOURCE = gstreamer-$(GSTREAMER1_VERSION).tar.xz
GSTREAMER1_SITE = https://gstreamer.freedesktop.org/src/gstreamer
GSTREAMER1_INSTALL_STAGING = YES
GSTREAMER1_LICENSE_FILES = COPYING
GSTREAMER1_LICENSE = LGPL-2.0+, LGPL-2.1+

GSTREAMER1_CONF_OPTS = \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dbenchmarks=disabled \
	-Dgtk_doc=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled \
	-Dgobject-cast-checks=disabled \
	-Dcheck=$(if $(BR2_PACKAGE_GSTREAMER1_CHECK),enabled,disabled) \
	-Dtracer_hooks=$(if $(BR2_PACKAGE_GSTREAMER1_TRACE),true,false) \
	-Doption-parsing=$(if $(BR2_PACKAGE_GSTREAMER1_PARSE),true,false) \
	-Dgst_debug=$(if $(BR2_PACKAGE_GSTREAMER1_GST_DEBUG),true,false) \
	-Dregistry=$(if $(BR2_PACKAGE_GSTREAMER1_PLUGIN_REGISTRY),true,false) \
	-Dtools=$(if $(BR2_PACKAGE_GSTREAMER1_INSTALL_TOOLS),enabled,disabled)

GSTREAMER1_DEPENDENCIES = \
	host-bison \
	host-flex \
	host-pkgconf \
	libglib2 \
	$(if $(BR2_PACKAGE_LIBUNWIND),libunwind) \
	$(if $(BR2_PACKAGE_VALGRIND),valgrind) \
	$(TARGET_NLS_DEPENDENCIES)

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
GSTREAMER1_CONF_OPTS += -Dintrospection=enabled
GSTREAMER1_DEPENDENCIES += gobject-introspection
else
GSTREAMER1_CONF_OPTS += -Dintrospection=disabled
endif

GSTREAMER1_LDFLAGS = $(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)

$(eval $(meson-package))
