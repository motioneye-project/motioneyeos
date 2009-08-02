#############################################################
#
# gamin
#
#############################################################
GAMIN_VERSION = 0.1.10
GAMIN_SOURCE = gamin-$(GAMIN_VERSION).tar.gz
GAMIN_SITE = http://www.gnome.org/~veillard/gamin/sources
GAMIN_AUTORECONF = NO
GAMIN_INSTALL_STAGING = YES
GAMIN_INSTALL_TARGET = YES

GAMIN_CONF_OPT = --program-prefix="" --disable-debug

ifneq ($(BR2_PACKAGE_PYTHON),y)
GAMIN_CONF_OPT += --without-python
endif

GAMIN_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

GAMIN_CONF_ENV = have_abstract_sockets=no

ifneq ($(BR2_LARGEFILE),y)
GAMIN_CONF_ENV += CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
endif

GAMIN_DEPENDENCIES = uclibc libglib2

$(eval $(call AUTOTARGETS,package,gamin))

