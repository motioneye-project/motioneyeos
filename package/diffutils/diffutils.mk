################################################################################
#
# diffutils
#
################################################################################

DIFFUTILS_VERSION = 3.5
DIFFUTILS_SOURCE = diffutils-$(DIFFUTILS_VERSION).tar.xz
DIFFUTILS_SITE = $(BR2_GNU_MIRROR)/diffutils
DIFFUTILS_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
DIFFUTILS_LICENSE = GPLv3+
DIFFUTILS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_BUSYBOX),y)
DIFFUTILS_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
