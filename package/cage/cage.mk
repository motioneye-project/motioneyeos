################################################################################
#
# cage
#
################################################################################

CAGE_VERSION = 6eb693c05b5b34d4ed5ad8234a9f79a14ac8e07d
CAGE_SITE = $(call github,Hjdskes,cage,$(CAGE_VERSION))
CAGE_LICENSE = MIT
CAGE_LICENSE_FILES = LICENSE
CAGE_DEPENDENCIES = host-pkgconf wlroots

ifeq ($(BR2_PACKAGE_XORG7),y)
CAGE_CONF_OPTS = -Dxwayland=true
else
CAGE_CONF_OPTS = -Dxwayland=false
endif

$(eval $(meson-package))
