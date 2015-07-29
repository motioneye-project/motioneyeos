################################################################################
#
# midori
#
################################################################################

MIDORI_VERSION = 0.5.9
MIDORI_SOURCE = midori_$(MIDORI_VERSION)_all_.tar.bz2
MIDORI_SITE = https://launchpad.net/midori/trunk/$(MIDORI_VERSION)/+download
MIDORI_LICENSE = LGPLv2.1+
MIDORI_LICENSE_FILES = COPYING
MIDORI_DEPENDENCIES = \
	host-intltool \
	host-librsvg \
	host-pkgconf \
	host-vala \
	host-python \
	libsoup \
	libxml2 \
	sqlite \
	webkitgtk24 \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)

MIDORI_CONF_OPTS = \
	-DUSE_ZEITGEIST=OFF

# Requires uClibc backtrace support, normally not enabled
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
define MIDORI_REMOVE_DEVPET
	rm -f $(@D)/extensions/devpet.vala
endef
MIDORI_POST_PATCH_HOOKS += MIDORI_REMOVE_DEVPET
endif

ifeq ($(BR2_PACKAGE_MIDORI_HTTPS),y)
MIDORI_DEPENDENCIES += glib-networking
endif

ifeq ($(BR2_PACKAGE_LIBGTK3),y)
MIDORI_CONF_OPTS += -DUSE_GTK3=ON -DHALF_BRO_INCOM_WEBKIT2=ON
MIDORI_DEPENDENCIES += libgtk3
else
MIDORI_CONF_OPTS += -DUSE_GTK3=OFF
MIDORI_DEPENDENCIES += libgtk2
endif

$(eval $(cmake-package))
