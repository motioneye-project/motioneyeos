################################################################################
#
# apr-util
#
################################################################################

APR_UTIL_VERSION = 1.4.1
APR_UTIL_SITE = http://archive.apache.org/dist/apr
APR_UTIL_LICENSE = Apache-2.0
APR_UTIL_LICENSE_FILES = LICENSE
APR_UTIL_INSTALL_STAGING = YES
APR_UTIL_DEPENDENCIES = apr sqlite neon zlib
APR_UTIL_CONF_OPT = \
	--with-apr=$(STAGING_DIR)/usr/bin/apr-1-config
APR_UTIL_CONFIG_SCRIPTS = apu-1-config

# When iconv is available, then use it to provide charset conversion
# features.
APR_UTIL_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

$(eval $(autotools-package))
