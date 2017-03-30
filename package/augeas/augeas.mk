################################################################################
#
# augeas
#
################################################################################

AUGEAS_VERSION = 1.7.0
AUGEAS_SITE = http://download.augeas.net
AUGEAS_INSTALL_STAGING = YES
AUGEAS_LICENSE = LGPL-2.1+
AUGEAS_LICENSE_FILES = COPYING
AUGEAS_DEPENDENCIES = host-pkgconf readline libxml2

# Fetch upstream patch to fix static linking
AUGEAS_PATCH = https://github.com/hercules-team/augeas/commit/05a27f4e374e9f0dc2cda6301b52d2a6b109b2e8.patch

AUGEAS_CONF_OPTS = --disable-gnulib-tests

# Remove the test lenses which occupy about 1.4 MB on the target
define AUGEAS_REMOVE_TEST_LENSES
	rm -rf $(TARGET_DIR)/usr/share/augeas/lenses/dist/tests
endef
AUGEAS_POST_INSTALL_TARGET_HOOKS += AUGEAS_REMOVE_TEST_LENSES

$(eval $(autotools-package))
