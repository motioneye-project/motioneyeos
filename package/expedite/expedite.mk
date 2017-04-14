################################################################################
#
# expedite
#
################################################################################

EXPEDITE_VERSION = 0529ce56b6fb01e9651e76461e9608e15a040fb3
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
