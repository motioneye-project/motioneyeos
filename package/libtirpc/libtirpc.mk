################################################################################
#
# libtirpc
#
################################################################################

LIBTIRPC_VERSION = 0.2.4
LIBTIRPC_SOURCE = libtirpc-$(LIBTIRPC_VERSION).tar.bz2
LIBTIRPC_SITE = http://downloads.sourceforge.net/project/libtirpc/libtirpc/$(LIBTIRPC_VERSION)
LIBTIRPC_LICENSE = BSD-3c
LIBTIRPC_LICENSE_FILES = COPYING

LIBTIRPC_INSTALL_STAGING = YES
LIBTIRPC_AUTORECONF = YES

# getrpcby{number,name} are only provided if 'GQ' is defined
LIBTIRPC_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -DGQ"

LIBTIRPC_CONF_OPT = --disable-gssapi

# We need host-pkgconf because the configure.ac contains a
# PKG_CHECK_MODULES macro call, and since we're autoreconfiguring this
# package, we need the source for this PKG_CHECK_MODULES macro, which
# comes from host-pkgconf. Other than that, pkgconf is only used to
# find if there is a gss implementation somewhere, which we don't
# support in Buildroot yet.
LIBTIRPC_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
