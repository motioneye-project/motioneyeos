################################################################################
#
# freetype
#
################################################################################

FREETYPE_VERSION = 2.8
FREETYPE_SOURCE = freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_SITE = http://download.savannah.gnu.org/releases/freetype
FREETYPE_INSTALL_STAGING = YES
FREETYPE_MAKE_OPTS = CCexe="$(HOSTCC)"
FREETYPE_LICENSE = Dual FTL/GPL-2.0+
FREETYPE_LICENSE_FILES = docs/LICENSE.TXT docs/FTL.TXT docs/GPLv2.TXT
FREETYPE_DEPENDENCIES = host-pkgconf
FREETYPE_CONFIG_SCRIPTS = freetype-config

HOST_FREETYPE_DEPENDENCIES = host-pkgconf
HOST_FREETYPE_CONF_OPTS = --without-zlib --without-bzip2 --without-png

# Regen required because the tarball ships with an experimental ltmain.sh
# that can't be patched by our infra.
# autogen.sh is because autotools stuff lives in other directories and
# even AUTORECONF with _OPTS doesn't do it properly.
# POST_PATCH is because we still need to patch libtool after the regen.
define FREETYPE_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
FREETYPE_POST_PATCH_HOOKS += FREETYPE_RUN_AUTOGEN
HOST_FREETYPE_POST_PATCH_HOOKS += FREETYPE_RUN_AUTOGEN
FREETYPE_DEPENDENCIES += host-automake host-autoconf host-libtool
HOST_FREETYPE_DEPENDENCIES += host-automake host-autoconf host-libtool

ifeq ($(BR2_PACKAGE_ZLIB),y)
FREETYPE_DEPENDENCIES += zlib
FREETYPE_CONF_OPTS += --with-zlib
else
FREETYPE_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
FREETYPE_DEPENDENCIES += bzip2
FREETYPE_CONF_OPTS += --with-bzip2
else
FREETYPE_CONF_OPTS += --without-bzip2
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
FREETYPE_DEPENDENCIES += libpng
FREETYPE_CONF_OPTS += LIBPNG_CFLAGS="`$(STAGING_DIR)/usr/bin/libpng-config --cflags`" \
	LIBPNG_LDFLAGS="`$(STAGING_DIR)/usr/bin/libpng-config --ldflags`"
FREETYPE_LIBPNG_LIBS = "`$(STAGING_DIR)/usr/bin/libpng-config --libs`"
else
FREETYPE_CONF_OPTS += --without-png
endif

# Extra fixing since includedir and libdir are expanded from configure values
define FREETYPE_FIX_CONFIG_FILE
	$(SED) 's:^includedir=.*:includedir="$${prefix}/include":' \
		-e 's:^libdir=.*:libdir="$${exec_prefix}/lib":' \
		$(STAGING_DIR)/usr/bin/freetype-config
endef
FREETYPE_POST_INSTALL_STAGING_HOOKS += FREETYPE_FIX_CONFIG_FILE

# libpng isn't included in freetype-config & freetype2.pc :-/
define FREETYPE_FIX_CONFIG_FILE_LIBS
	$(SED) "s,^Libs.private:,& $(FREETYPE_LIBPNG_LIBS)," \
		$(STAGING_DIR)/usr/lib/pkgconfig/freetype2.pc
	$(SED) "s,-lfreetype,& $(FREETYPE_LIBPNG_LIBS)," \
		$(STAGING_DIR)/usr/bin/freetype-config
endef
FREETYPE_POST_INSTALL_STAGING_HOOKS += FREETYPE_FIX_CONFIG_FILE_LIBS

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# freetype-patch and host-freetype-patch use autogen.sh so add
# host-automake as a order-only-prerequisite because it is a phony
# target.
$(FREETYPE_TARGET_PATCH) $(HOST_FREETYPE_TARGET_PATCH): | host-automake
