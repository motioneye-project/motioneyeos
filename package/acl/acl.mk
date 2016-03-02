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
ACL_LICENSE = GPLv2+ (programs), LGPLv2.1+ (libraries)
ACL_LICENSE_FILES = doc/COPYING doc/COPYING.LGPL

# While the configuration system uses autoconf, the Makefiles are
# hand-written and do not use automake. Therefore, we have to hack
# around their deficiencies by passing installation paths.
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

$(eval $(autotools-package))
