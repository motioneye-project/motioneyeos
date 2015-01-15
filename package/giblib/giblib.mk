################################################################################
#
# giblib
#
################################################################################

GIBLIB_VERSION = 1.2.4
GIBLIB_SITE = http://linuxbrit.co.uk/downloads
GIBLIB_INSTALL_STAGING = YES
GIBLIB_DEPENDENCIES = imlib2
GIBLIB_AUTORECONF = YES
GIBLIB_CONF_OPTS = \
	--with-imlib2-prefix=$(STAGING_DIR)/usr \
	--with-imlib2-exec-prefix=$(STAGING_DIR)/usr
GIBLIB_CONFIG_SCRIPTS = giblib-config
GIBLIB_LICENSE = MIT
GIBLIB_LICENSE_FILES = COPYING

$(eval $(autotools-package))
