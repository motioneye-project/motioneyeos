#############################################################
#
# gamin
#
#############################################################
GAMIN_VERSION = 0.1.9
GAMIN_SOURCE = gamin-$(GAMIN_VERSION).tar.gz
GAMIN_SITE = http://www.gnome.org/~veillard/gamin/sources
GAMIN_AUTORECONF = NO
GAMIN_INSTALL_STAGING = YES
GAMIN_INSTALL_TARGET = YES

GAMIN_CONF_OPT = --program-prefix=""

GAMIN_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

GAMIN_CONF_ENV = have_abstract_sockets=no

GAMIN_DEPENDENCIES = uclibc libgtk2

$(eval $(call AUTOTARGETS,package,gamin))

