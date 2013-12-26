################################################################################
#
# freetype
#
################################################################################

FREETYPE_VERSION = 2.5.2
FREETYPE_SOURCE = freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_SITE = http://downloads.sourceforge.net/project/freetype/freetype2/$(FREETYPE_VERSION)
FREETYPE_INSTALL_STAGING = YES
FREETYPE_MAKE_OPT = CCexe="$(HOSTCC)"
FREETYPE_LICENSE = Dual FTL/GPLv2+
FREETYPE_LICENSE_FILES = docs/FTL.TXT docs/GPLv2.TXT
FREETYPE_DEPENDENCIES = host-pkgconf
FREETYPE_CONFIG_SCRIPTS = freetype-config

HOST_FREETYPE_DEPENDENCIES = host-pkgconf
HOST_FREETYPE_CONF_OPT = --without-zlib --without-bzip2 --without-png

ifeq ($(BR2_PACKAGE_ZLIB),y)
FREETYPE_DEPENDENCIES += zlib
FREETYPE_CONF_OPT += --with-zlib
else
FREETYPE_CONF_OPT += --without-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
FREETYPE_DEPENDENCIES += bzip2
FREETYPE_CONF_OPT += --with-bzip2
else
FREETYPE_CONF_OPT += --without-bzip2
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
FREETYPE_DEPENDENCIES += libpng
FREETYPE_CONF_OPT += LIBPNG_CFLAGS="`$(STAGING_DIR)/usr/bin/libpng-config --cflags`" \
	LIBPNG_LDFLAGS="`$(STAGING_DIR)/usr/bin/libpng-config --ldflags`"
FREETYPE_LIBPNG_LIBS = "`$(STAGING_DIR)/usr/bin/libpng-config --libs`"
else
FREETYPE_CONF_OPT += --without-png
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

# Version 2.5.1 reorganized headers out of freetype2/freetype
# It's unexpected for some packages so symlink it until it spreads upstream
define FREETYPE_FIX_FREETYPE_INCLUDE
	ln -sf . $(STAGING_DIR)/usr/include/freetype2/freetype
endef
FREETYPE_POST_INSTALL_STAGING_HOOKS += FREETYPE_FIX_FREETYPE_INCLUDE
define HOST_FREETYPE_FIX_FREETYPE_INCLUDE
	ln -sf . $(HOST_DIR)/usr/include/freetype2/freetype
endef
HOST_FREETYPE_POST_INSTALL_HOOKS += HOST_FREETYPE_FIX_FREETYPE_INCLUDE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
