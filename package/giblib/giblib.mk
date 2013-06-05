################################################################################
#
# giblib
#
################################################################################

GIBLIB_VERSION = 1.2.4
GIBLIB_SOURCE = giblib-$(GIBLIB_VERSION).tar.gz
GIBLIB_SITE = http://linuxbrit.co.uk/downloads/
GIBLIB_INSTALL_STAGING = YES
GIBLIB_DEPENDENCIES = imlib2
GIBLIB_AUTORECONF = YES
GIBLIB_AUTORECONF_OPT = --install
GIBLIB_CONF_OPT = --with-imlib2-prefix=$(STAGING_DIR)/usr \
		  --with-imlib2-exec-prefix=$(STAGING_DIR)/usr
GIBLIB_CONFIG_SCRIPTS = giblib-config

$(eval $(autotools-package))
