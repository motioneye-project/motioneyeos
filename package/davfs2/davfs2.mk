################################################################################
#
# davfs2
#
################################################################################

DAVFS2_VERSION = 1.5.6
DAVFS2_SITE = http://download.savannah.nongnu.org/releases/davfs2
DAVFS2_LICENSE = GPL-3.0+
DAVFS2_LICENSE_FILES = COPYING

DAVFS2_DEPENDENCIES = \
	neon \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv) \
	$(TARGET_NLS_DEPENDENCIES)

DAVFS2_CONF_ENV += \
	ac_cv_path_NEON_CONFIG=$(STAGING_DIR)/usr/bin/neon-config \
	LIBS=$(TARGET_NLS_LIBS)

$(eval $(autotools-package))
