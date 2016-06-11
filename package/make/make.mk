################################################################################
#
# make
#
################################################################################

MAKE_VERSION = 4.2.1
MAKE_SOURCE = make-$(MAKE_VERSION).tar.bz2
MAKE_SITE = $(BR2_GNU_MIRROR)/make
MAKE_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
MAKE_LICENSE = GPLv3+
MAKE_LICENSE_FILES = COPYING

MAKE_CONF_OPTS = --without-guile

# Disable the 'load' operation for static builds since it needs dlopen
ifeq ($(BR2_STATIC_LIBS),y)
MAKE_CONF_OPTS += --disable-load
endif

$(eval $(autotools-package))
