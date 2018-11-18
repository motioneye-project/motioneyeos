################################################################################
#
# davfs2
#
################################################################################

DAVFS2_VERSION = 1.5.4
DAVFS2_SITE = http://download.savannah.nongnu.org/releases/davfs2
DAVFS2_LICENSE = GPL-3.0+
DAVFS2_LICENSE_FILES = COPYING

DAVFS2_DEPENDENCIES = neon

DAVFS2_CONF_ENV += \
	ac_cv_path_NEON_CONFIG=$(STAGING_DIR)/usr/bin/neon-config

$(eval $(autotools-package))
