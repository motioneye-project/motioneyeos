#############################################################
#
# attr
#
#############################################################

ATTR_VERSION = 2.4.46
ATTR_SOURCE = attr-$(ATTR_VERSION).src.tar.gz
ATTR_SITE = http://download.savannah.gnu.org/releases/attr
ATTR_INSTALL_STAGING = YES
ATTR_CONF_OPT = --enable-gettext=no

# While the configuration system uses autoconf, the Makefiles are
# hand-written and do not use automake. Therefore, we have to hack
# around their deficiencies by passing installation paths.
ATTR_INSTALL_STAGING_OPT = 			\
	prefix=$(STAGING_DIR)/usr 		\
	exec_prefix=$(STAGING_DIR)/usr 		\
	PKG_DEVLIB_DIR=$(STAGING_DIR)/usr/lib 	\
	install-dev install-lib

ATTR_INSTALL_TARGET_OPT = 			\
	prefix=$(TARGET_DIR)/usr 		\
	exec_prefix=$(TARGET_DIR)/usr 		\
	install install-lib

$(eval $(autotools-package))
