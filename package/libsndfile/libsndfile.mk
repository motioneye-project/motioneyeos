################################################################################
#
# libsndfile
#
################################################################################

LIBSNDFILE_VERSION = 1.0.27
LIBSNDFILE_SITE = http://www.mega-nerd.com/libsndfile/files
LIBSNDFILE_INSTALL_STAGING = YES
LIBSNDFILE_LICENSE = LGPLv2.1+
LIBSNDFILE_LICENSE_FILES = COPYING

LIBSNDFILE_CONF_OPTS = \
	--disable-sqlite \
	--disable-alsa \
	--disable-external-libs

$(eval $(autotools-package))
