################################################################################
#
# openipmi
#
################################################################################

OPENIPMI_VERSION = 2.0.21
OPENIPMI_SITE = http://sourceforge.net/projects/openipmi/files/OpenIPMI%202.0%20Library
OPENIPMI_SOURCE = OpenIPMI-2.0.21.tar.gz
OPENIPMI_PATCH = \
	http://sourceforge.net/p/openipmi/patches/26/attachment/0001-ui-use-standard-uint32_t.patch
OPENIPMI_LICENSE = LGPLv2+, GPLv2+, BSD-3c
OPENIPMI_LICENSE_FILES = COPYING.LIB COPYING COPYING.BSD
OPENIPMI_DEPENDENCIES = popt ncurses host-pkgconf
# Patching Makefile.am
OPENIPMI_AUTORECONF = YES
OPENIPMI_CONF_ENV = ac_cv_path_pkgprog="$(PKG_CONFIG_HOST_BINARY)"
OPENIPMI_CONF_OPTS = \
	--with-glib=no \
	--with-glib12=no \
	--with-tcl=no \
	--with-perl=no \
	--with-python=no \
	--with-swig=no

ifeq ($(BR2_PACKAGE_GDBM),y)
OPENIPMI_DEPENDENCIES += gdbm
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
OPENIPMI_DEPENDENCIES += openssl
OPENIPMI_CONF_OPTS += --with-openssl=yes
else
OPENIPMI_CONF_OPTS += --with-openssl=no
endif

ifeq ($(BR2_PACKAGE_NETSNMP),y)
OPENIPMI_DEPENDENCIES += netsnmp
OPENIPMI_CONF_OPTS += --with-ucdsnmp=yes
else
OPENIPMI_CONF_OPTS += --with-ucdsnmp=no
endif

$(eval $(autotools-package))
