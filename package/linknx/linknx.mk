################################################################################
#
# linknx
#
################################################################################

LINKNX_VERSION = 0.0.1.32
LINKNX_SITE = http://downloads.sourceforge.net/project/linknx/linknx/linknx-$(LINKNX_VERSION)
LINKNX_LICENSE = GPLv2+
LINKNX_INSTALL_STAGING = YES
# Patching acinclude.m4
LINKNX_AUTORECONF = YES
LINKNX_CONF_OPTS = \
	--without-lua \
	--without-log4cpp \
	--without-pth-test \
	--with-pth=$(STAGING_DIR)/usr \
	--disable-smtp \
	--with-libcurl=$(STAGING_DIR)/usr/bin/curl-config

LINKNX_DEPENDENCIES = libpthsem libcurl \
	$(if $(BR2_PACKAGE_ARGP_STANDALONE),argp-standalone)

# This is needed to make autoreconf happy
define LINKNX_CREATE_MISSING_FILES
	touch $(@D)/NEWS $(@D)/AUTHORS $(@D)/README
endef
LINKNX_POST_EXTRACT_HOOKS += LINKNX_CREATE_MISSING_FILES

ifeq ($(BR2_PACKAGE_MYSQL),y)
LINKNX_CONF_OPTS += --with-mysql=$(STAGING_DIR)/usr/bin/mysql_config
LINKNX_DEPENDENCIES += mysql
else
LINKNX_CONF_OPTS += --without-mysql
endif

$(eval $(autotools-package))
