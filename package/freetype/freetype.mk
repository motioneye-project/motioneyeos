################################################################################
#
# freetype
#
################################################################################

FREETYPE_VERSION = 2.4.12
FREETYPE_SOURCE = freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_SITE = http://downloads.sourceforge.net/project/freetype/freetype2/$(FREETYPE_VERSION)
FREETYPE_INSTALL_STAGING = YES
FREETYPE_MAKE_OPT = CCexe="$(HOSTCC)"
FREETYPE_LICENSE = Dual FTL/GPLv2+
FREETYPE_LICENSE_FILES = docs/FTL.TXT docs/GPLv2.TXT
FREETYPE_DEPENDENCIES = host-pkgconf \
	$(if $(BR2_PACKAGE_ZLIB),zlib) \
	$(if $(BR2_PACKAGE_BZIP2),bzip2)
FREETYPE_CONFIG_SCRIPTS = freetype-config

HOST_FREETYPE_DEPENDENCIES = host-pkgconf

# Extra fixing since includedir and libdir are expanded from configure values
define FREETYPE_FIX_CONFIG_FILE
	$(SED) 's:^includedir=.*:includedir="$${prefix}/include":' \
		-e 's:^libdir=.*:libdir="$${exec_prefix}/lib":' \
		$(STAGING_DIR)/usr/bin/freetype-config
endef
FREETYPE_POST_INSTALL_STAGING_HOOKS += FREETYPE_FIX_CONFIG_FILE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
