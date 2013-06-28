################################################################################
#
# gamin
#
################################################################################

GAMIN_VERSION = 0.1.10
GAMIN_SOURCE = gamin-$(GAMIN_VERSION).tar.gz
GAMIN_SITE = http://www.gnome.org/~veillard/gamin/sources
GAMIN_AUTORECONF = YES
GAMIN_INSTALL_STAGING = YES
GAMIN_LICENSE = LGPLv2+
GAMIN_LICENSE_FILES = COPYING
GAMIN_CONF_OPT = --disable-debug

# python support broken
GAMIN_CONF_OPT += --without-python

GAMIN_CONF_ENV = have_abstract_sockets=no

ifneq ($(BR2_LARGEFILE),y)
GAMIN_CONF_ENV += CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
endif

GAMIN_DEPENDENCIES = libglib2

$(eval $(autotools-package))

