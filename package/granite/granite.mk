################################################################################
#
# granite
#
################################################################################

GRANITE_VERSION = 5.4.0
GRANITE_SITE = $(call github,elementary,granite,$(GRANITE_VERSION))
GRANITE_DEPENDENCIES = host-pkgconf host-vala libgee libglib2 libgtk3
GRANITE_INSTALL_STAGING = YES
GRANITE_LICENSE = LGPL-3.0+
GRANITE_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
GRANITE_CONF_OPTS += -Dintrospection=true
GRANITE_DEPENDENCIES += gobject-introspection
else
GRANITE_CONF_OPTS += -Dintrospection=false
endif

$(eval $(meson-package))
