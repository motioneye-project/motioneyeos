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
LIBOPING_LICENSE = LGPL-2.1+, GPL-2.0
LIBOPING_LICENSE_FILES = COPYING

$(eval $(autotools-package))
