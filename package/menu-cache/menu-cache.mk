################################################################################
#
# menu-cache
#
################################################################################

MENU_CACHE_VERSION_MAJOR = 1.0
MENU_CACHE_VERSION = $(MENU_CACHE_VERSION_MAJOR).1
MENU_CACHE_SOURCE = menu-cache-$(MENU_CACHE_VERSION).tar.xz
MENU_CACHE_SITE = http://sourceforge.net/projects/lxde/files/menu-cache/$(MENU_CACHE_VERSION_MAJOR)
MENU_CACHE_DEPENDENCIES = libfm-extra libglib2
MENU_CACHE_LICENSE = LGPLv2.1
MENU_CACHE_LICENSE_FILES = COPYING
MENU_CACHE_INSTALL_STAGING = YES

$(eval $(autotools-package))
