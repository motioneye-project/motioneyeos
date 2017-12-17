################################################################################
#
# curlftpfs
#
################################################################################

CURLFTPFS_VERSION = 0.9.2
CURLFTPFS_SITE = http://downloads.sourceforge.net/project/curlftpfs/curlftpfs/$(CURLFTPFS_VERSION)
CURLFTPFS_CONF_ENV = ac_cv_path__libcurl_config=$(STAGING_DIR)/usr/bin/curl-config
CURLFTPFS_LICENSE = GPL-2.0
CURLFTPFS_LICENSE_FILES = COPYING
CURLFTPFS_DEPENDENCIES = \
	libglib2 libfuse openssl libcurl \
	$(TARGET_NLS_DEPENDENCIES) \
	$(if $(BR2_ENABLE_LOCALE),,libiconv)

$(eval $(autotools-package))
