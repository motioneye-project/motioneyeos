################################################################################
#
# libpagekite
#
################################################################################

LIBPAGEKITE_VERSION = 0.91.190530
LIBPAGEKITE_SITE = $(call github,pagekite,libpagekite,v$(LIBPAGEKITE_VERSION))

# pkrelay is AGPL-3.0+ but is not built
LIBPAGEKITE_LICENSE = Apache-2.0 or AGPL-3.0+
LIBPAGEKITE_LICENSE_FILES = doc/COPYING.md doc/LICENSE-2.0.txt doc/AGPLv3.txt

LIBPAGEKITE_DEPENDENCIES = host-pkgconf libev openssl
LIBPAGEKITE_INSTALL_STAGING = YES

# Sources from git, no configure included
LIBPAGEKITE_AUTORECONF = YES

LIBPAGEKITE_CONF_OPTS = \
	--with-openssl \
	--without-tests \
	--with-os-libev \
	--without-java \
	--without-agpl-relay \
	--without-ds-logfmt

$(eval $(autotools-package))
