################################################################################
#
# attr
#
################################################################################

ATTR_VERSION = 2.4.47
ATTR_SOURCE = attr-$(ATTR_VERSION).src.tar.gz
ATTR_SITE = http://download.savannah.gnu.org/releases/attr
ATTR_INSTALL_STAGING = YES
ATTR_CONF_OPTS = --enable-gettext=no
HOST_ATTR_CONF_OPTS = --enable-gettext=no
ATTR_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (libraries)
ATTR_LICENSE_FILES = doc/COPYING doc/COPYING.LGPL

# While the configuration system uses autoconf, the Makefiles are
# hand-written and do not use automake. Therefore, we have to hack
# around their deficiencies by passing installation paths.
ATTR_INSTALL_STAGING_OPTS = \
	prefix=$(STAGING_DIR)/usr \
	exec_prefix=$(STAGING_DIR)/usr \
	PKG_DEVLIB_DIR=$(STAGING_DIR)/usr/lib \
	install-dev install-lib

ATTR_INSTALL_TARGET_OPTS = \
	prefix=$(TARGET_DIR)/usr \
	exec_prefix=$(TARGET_DIR)/usr \
	install install-lib

HOST_ATTR_INSTALL_OPTS = \
	prefix=$(HOST_DIR)/usr \
	exec_prefix=$(HOST_DIR)/usr \
	install-dev install-lib

# The libdir variable in libattr.la is empty, so let's fix it. This is
# probably due to attr not using automake, and not doing fully the
# right thing with libtool.
define ATTR_FIX_LIBTOOL_LA_LIBDIR
	$(SED) "s,libdir=.*,libdir='$(STAGING_DIR)'," \
		$(STAGING_DIR)/usr/lib/libattr.la
endef

ATTR_POST_INSTALL_STAGING_HOOKS += ATTR_FIX_LIBTOOL_LA_LIBDIR

$(eval $(autotools-package))
$(eval $(host-autotools-package))
