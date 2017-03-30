################################################################################
#
# acl
#
################################################################################

ACL_VERSION = 2.2.52
ACL_SOURCE = acl-$(ACL_VERSION).src.tar.gz
ACL_SITE = http://download.savannah.gnu.org/releases/acl
ACL_INSTALL_STAGING = YES
ACL_DEPENDENCIES = attr
ACL_CONF_OPTS = --enable-gettext=no
ACL_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (libraries)
ACL_LICENSE_FILES = doc/COPYING doc/COPYING.LGPL

# While the configuration system uses autoconf, the Makefiles are
# hand-written and do not use automake. Therefore, we have to hack
# around their deficiencies by:
# - explicitly passing CFLAGS (LDFLAGS are passed on from configure,
#   CFLAGS are not).
# - explicitly passing the installation prefix, not using DESTDIR.

ACL_MAKE_ENV = CFLAGS="$(TARGET_CFLAGS)"

ACL_INSTALL_STAGING_OPTS = \
	prefix=$(STAGING_DIR)/usr \
	exec_prefix=$(STAGING_DIR)/usr \
	PKG_DEVLIB_DIR=$(STAGING_DIR)/usr/lib \
	install-dev install-lib

ACL_INSTALL_TARGET_OPTS = \
	prefix=$(TARGET_DIR)/usr \
	exec_prefix=$(TARGET_DIR)/usr \
	install install-lib

# The libdir variable in libacl.la is empty, so let's fix it. This is
# probably due to acl not using automake, and not doing fully the
# right thing with libtool.
define ACL_FIX_LIBTOOL_LA_LIBDIR
	$(SED) "s,libdir=.*,libdir='$(STAGING_DIR)'," \
		$(STAGING_DIR)/usr/lib/libacl.la
endef

ACL_POST_INSTALL_STAGING_HOOKS += ACL_FIX_LIBTOOL_LA_LIBDIR

HOST_ACL_DEPENDENCIES = host-attr
HOST_ACL_CONF_OPTS = --enable-gettext=no
HOST_ACL_MAKE_ENV = CFLAGS="$(HOST_CFLAGS)"
HOST_ACL_INSTALL_OPTS = \
	prefix=$(HOST_DIR)/usr \
	exec_prefix=$(HOST_DIR)/usr \
	PKG_DEVLIB_DIR=$(HOST_DIR)/usr/lib \
	install-dev install-lib
# For the host, libacl.la is correct, no fixup needed.

$(eval $(autotools-package))
$(eval $(host-autotools-package))
