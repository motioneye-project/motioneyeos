#############################################################
#
# curlftpfs
#
#############################################################

CURLFTPFS_VERSION = 0.9.2
CURLFTPFS_SITE = http://downloads.sourceforge.net/project/curlftpfs/curlftpfs/$(CURLFTPFS_VERSION)
CURLFTPFS_DEPENDENCIES = \
	libglib2 libfuse openssl libcurl \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) \
	$(if $(BR2_ENABLE_LOCALE),,libiconv)

$(eval $(autotools-package))
