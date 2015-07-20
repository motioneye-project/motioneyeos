################################################################################
#
# c-icap-modules
#
################################################################################

C_ICAP_MODULES_VERSION = 0.3.2
C_ICAP_MODULES_SOURCE = c_icap_modules-$(C_ICAP_MODULES_VERSION).tar.gz
C_ICAP_MODULES_SITE = http://downloads.sourceforge.net/c-icap/
C_ICAP_MODULES_LICENSE = GPLv2+
C_ICAP_MODULES_LICENSE_FILES = COPYING
C_ICAP_MODULES_DEPENDENCIES = c-icap

C_ICAP_MODULES_CONF_OPTS = \
	--with-c-icap=$(STAGING_DIR)/usr/ \
	--without-clamav

ifeq ($(BR2_PACKAGE_ZLIB),y)
C_ICAP_MODULES_CONF_OPTS += --with-zlib
C_ICAP_MODULES_DEPENDENCIES += zlib
else
C_ICAP_MODULES_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
C_ICAP_MODULES_CONF_OPTS += --with-bdb
C_ICAP_MODULES_DEPENDENCIES += berkeleydb
else
C_ICAP_MODULES_CONF_OPTS += --without-bdb
endif

$(eval $(autotools-package))
