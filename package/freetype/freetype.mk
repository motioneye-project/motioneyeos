################################################################################
#
# freetype
#
################################################################################

FREETYPE_VERSION = 2.9.1
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

# since 2.9.1 needed for freetype-config install
FREETYPE_CONF_OPTS += --enable-freetype-config
HOST_FREETYPE_CONF_OPTS += --enable-freetype-config

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
