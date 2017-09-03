################################################################################
#
# log4cpp
#
################################################################################

LOG4CPP_VERSION_MAJOR = 1.1
LOG4CPP_VERSION = $(LOG4CPP_VERSION_MAJOR).3
LOG4CPP_SITE = http://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-$(LOG4CPP_VERSION_MAJOR)
LOG4CPP_SUBDIR = log4cpp
# The "or later" is indicated in the HTML documentation
LOG4CPP_LICENSE = LGPL-2.1+
LOG4CPP_LICENSE_FILES = log4cpp/COPYING
LOG4CPP_INSTALL_STAGING = YES
LOG4CPP_CONF_OPTS = --enable-doxygen=no --enable-dot=no
# needed to fix broken configure script
LOG4CPP_AUTORECONF = YES
LOG4CPP_AUTORECONF_OPTS = -I m4

# The default <pkg>_CONFIG_SCRIPTS handling does not apply
define LOG4CPP_STAGING_CONFIG_SCRIPT_FIXUP
	$(SED) 's,prefix="/usr",prefix="$(STAGING_DIR)/usr",' \
		-e 's,exec_prefix="/usr",prefix="$(STAGING_DIR)/usr",' \
		$(STAGING_DIR)/usr/bin/log4cpp-config
endef

LOG4CPP_POST_INSTALL_STAGING_HOOKS += LOG4CPP_STAGING_CONFIG_SCRIPT_FIXUP

define LOG4CPP_TARGET_CONFIG_SCRIPT_REMOVE
	$(RM) $(TARGET_DIR)/usr/bin/log4cpp-config
endef

LOG4CPP_POST_INSTALL_TARGET_HOOKS += LOG4CPP_TARGET_CONFIG_SCRIPT_REMOVE

$(eval $(autotools-package))
