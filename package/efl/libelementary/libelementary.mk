################################################################################
#
# libelementary
#
################################################################################

LIBELEMENTARY_VERSION = $(EFL_VERSION)
LIBELEMENTARY_SOURCE = elementary-$(LIBELEMENTARY_VERSION).tar.xz
LIBELEMENTARY_SITE = http://download.enlightenment.org/rel/libs/elementary
LIBELEMENTARY_LICENSE = LGPLv2.1
LIBELEMENTARY_LICENSE_FILES = COPYING

LIBELEMENTARY_INSTALL_STAGING = YES

LIBELEMENTARY_DEPENDENCIES = host-pkgconf host-libefl host-libelementary libefl

LIBELEMENTARY_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eet-eet=$(HOST_DIR)/usr/bin/eet \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--with-eldbus_codegen=$(HOST_DIR)/usr/bin/eldbus-codegen \
	--with-elm-prefs-cc=$(HOST_DIR)/usr/bin/elm_prefs_cc \
	--with-doxygen=no \
	--disable-elementary-test

# We need a host package in order to provide elm_prefs_cc and
# elementary_codegen.
HOST_LIBELEMENTARY_DEPENDENCIES = host-pkgconf host-libefl
HOST_LIBELEMENTARY_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eet-eet=$(HOST_DIR)/usr/bin/eet \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--with-doxygen=no \
	--disable-elementary-test

$(eval $(autotools-package))
$(eval $(host-autotools-package))
