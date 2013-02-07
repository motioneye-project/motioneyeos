#############################################################
#
# freetype
#
#############################################################

FREETYPE_VERSION = 2.4.11
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

$(eval $(autotools-package))
$(eval $(host-autotools-package))
