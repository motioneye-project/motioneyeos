################################################################################
#
# patch
#
################################################################################

PATCH_VERSION = 2.7.6
PATCH_SOURCE = patch-$(PATCH_VERSION).tar.xz
PATCH_SITE = $(BR2_GNU_MIRROR)/patch
PATCH_LICENSE = GPL-3.0+
PATCH_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_ATTR),y)
PATCH_CONF_OPTS += --enable-attr
PATCH_DEPENDENCIES += attr
else
PATCH_CONF_OPTS += --disable-attr
endif

$(eval $(autotools-package))
