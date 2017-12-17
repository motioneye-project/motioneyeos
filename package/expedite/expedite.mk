################################################################################
#
# expedite
#
################################################################################

EXPEDITE_VERSION = e7b11dd328d9db82b49cde795944a721beaf0112
EXPEDITE_SITE = http://git.enlightenment.org/tools/expedite.git
EXPEDITE_SITE_METHOD = git
EXPEDITE_LICENSE = BSD-2-Clause
EXPEDITE_LICENSE_FILES = COPYING

EXPEDITE_DEPENDENCIES = host-efl host-pkgconf efl

# There is no configure script in the git tree.
EXPEDITE_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_EFL_X_XLIB),y)
EXPEDITE_CONF_OPTS += --with-x=$(STAGING_DIR) \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib
endif

$(eval $(autotools-package))
