################################################################################
#
# gamin
#
################################################################################

GAMIN_VERSION = 0.1.10
GAMIN_SITE = http://www.gnome.org/~veillard/gamin/sources
GAMIN_AUTORECONF = YES
GAMIN_INSTALL_STAGING = YES
GAMIN_LICENSE = LGPL-2.0+
GAMIN_LICENSE_FILES = COPYING

# python support broken
GAMIN_CONF_OPTS += --without-python

GAMIN_CONF_ENV = have_abstract_sockets=no

GAMIN_DEPENDENCIES = libglib2

$(eval $(autotools-package))
