################################################################################
#
# liboping
#
################################################################################

LIBOPING_VERSION = 1.9.0
LIBOPING_SITE = http://noping.cc/files
LIBOPING_SOURCE = liboping-$(LIBOPING_VERSION).tar.bz2
LIBOPING_INSTALL_STAGING = YES
LIBOPING_DEPENDENCIES = $(if $(BR2_PACKAGE_NCURSES),ncurses)
LIBOPING_CONF_OPTS = --without-perl-bindings
LIBOPING_LICENSE = LGPLv2.1+, GPLv2
LIBOPING_LICENSE_FILES = COPYING

LIBOPING_AUTORECONF = YES

$(eval $(autotools-package))
