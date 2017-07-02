################################################################################
#
# libstrophe
#
################################################################################

LIBSTROPHE_VERSION = 0.8.8
LIBSTROPHE_SITE = $(call github,strophe,libstrophe,$(LIBSTROPHE_VERSION))
LIBSTROPHE_DEPENDENCIES = openssl host-pkgconf
# Doesn't ship configure
LIBSTROPHE_AUTORECONF = YES
LIBSTROPHE_LICENSE = MIT or GPL-3.0
LIBSTROPHE_LICENSE_FILES = MIT-LICENSE.txt GPL-LICENSE.txt
LIBSTROPHE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_EXPAT),y)
# Passing --without-libxml2 doesn't work, due to how AC_ARG_WITH is
# used in configure.ac. As long as --with-libxml2 is *not* passed, the
# configure script assumes expat should be used.
LIBSTROPHE_DEPENDENCIES += expat
else
LIBSTROPHE_CONF_OPTS += --with-libxml2
LIBSTROPHE_DEPENDENCIES += libxml2
endif

$(eval $(autotools-package))
