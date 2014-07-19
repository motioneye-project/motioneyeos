################################################################################
#
# make
#
################################################################################

MAKE_VERSION = 4.0
MAKE_SOURCE = make-$(MAKE_VERSION).tar.bz2
MAKE_SITE = $(BR2_GNU_MIRROR)/make
MAKE_LICENSE = GPLv3+
MAKE_LICENSE_FILES = COPYING

MAKE_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)

$(eval $(autotools-package))
