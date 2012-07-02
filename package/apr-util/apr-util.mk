#############################################################
#
# apr-util
#
#############################################################
APR_UTIL_VERSION = 1.4.1
APR_UTIL_SITE = http://archive.apache.org/dist/apr
APR_UTIL_INSTALL_STAGING = YES
APR_UTIL_DEPENDENCIES = apr sqlite neon zlib
APR_UTIL_CONF_OPT = \
	--with-apr=$(BUILD_DIR)/apr-$(APR_VERSION) \

$(eval $(autotools-package))
