################################################################################
#
# elementary
#
################################################################################

ELEMENTARY_VERSION = 1.15.3
ELEMENTARY_SOURCE = elementary-$(ELEMENTARY_VERSION).tar.xz
ELEMENTARY_SITE = http://download.enlightenment.org/rel/libs/elementary
ELEMENTARY_LICENSE = LGPLv2.1
ELEMENTARY_LICENSE_FILES = COPYING

ELEMENTARY_INSTALL_STAGING = YES

ELEMENTARY_DEPENDENCIES = host-pkgconf host-efl host-elementary efl

ELEMENTARY_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eet-eet=$(HOST_DIR)/usr/bin/eet \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--with-eldbus_codegen=$(HOST_DIR)/usr/bin/eldbus-codegen \
	--with-elm-prefs-cc=$(HOST_DIR)/usr/bin/elm_prefs_cc \
	--with-doxygen=no \
	--disable-elementary-test

# We need a host package in order to provide elm_prefs_cc and
# elementary_codegen.
HOST_ELEMENTARY_DEPENDENCIES = host-pkgconf host-efl
HOST_ELEMENTARY_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eet-eet=$(HOST_DIR)/usr/bin/eet \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--with-doxygen=no \
	--disable-elementary-test

$(eval $(autotools-package))
$(eval $(host-autotools-package))
