################################################################################
#
# ecryptfs-utils
#
################################################################################

ECRYPTFS_UTILS_VERSION = 111
ECRYPTFS_UTILS_SOURCE = ecryptfs-utils_$(ECRYPTFS_UTILS_VERSION).orig.tar.gz
ECRYPTFS_UTILS_SITE = https://launchpad.net/ecryptfs/trunk/$(ECRYPTFS_UTILS_VERSION)/+download
ECRYPTFS_UTILS_LICENSE = GPL-2.0+
ECRYPTFS_UTILS_LICENSE_FILES = COPYING

ECRYPTFS_UTILS_DEPENDENCIES = keyutils libnss host-intltool
ECRYPTFS_UTILS_CONF_OPTS = --disable-pywrap

#Needed for build system to find pk11func.h and libnss3.so
ECRYPTFS_UTILS_CONF_ENV = \
	NSS_CFLAGS="-I$(STAGING_DIR)/usr/include/nss -I$(STAGING_DIR)/usr/include/nspr" \
	NSS_LIBS="-lnss3"

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
ECRYPTFS_UTILS_CONF_OPTS += --enable-pam
ECRYPTFS_UTILS_DEPENDENCIES += linux-pam
else
ECRYPTFS_UTILS_CONF_OPTS += --disable-pam
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ECRYPTFS_UTILS_CONF_OPTS += --enable-openssl
ECRYPTFS_UTILS_DEPENDENCIES += openssl
else
ECRYPTFS_UTILS_CONF_OPTS += --disable-openssl
endif

$(eval $(autotools-package))
