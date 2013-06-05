################################################################################
#
# liboping
#
################################################################################

LIBOPING_VERSION = 1.6.2
LIBOPING_SITE = http://verplant.org/liboping/files
LIBOPING_INSTALL_STAGING = YES
LIBOPING_DEPENDENCIES = $(if $(BR2_PACKAGE_NCURSES),ncurses)
LIBOPING_CONF_OPT = --without-perl-bindings
LIBOPING_LICENSE = LGPLv2.1+ GPLv2
LIBOPING_LICENSE_FILES = COPYING

$(eval $(autotools-package))
