################################################################################
#
# liboping
#
################################################################################

LIBOPING_VERSION = 1.7.0
LIBOPING_SITE = http://verplant.org/liboping/files
LIBOPING_INSTALL_STAGING = YES
LIBOPING_DEPENDENCIES = $(if $(BR2_PACKAGE_NCURSES),ncurses)
LIBOPING_CONF_OPTS = --without-perl-bindings
LIBOPING_LICENSE = LGPLv2.1+ GPLv2
LIBOPING_LICENSE_FILES = COPYING

$(eval $(autotools-package))
