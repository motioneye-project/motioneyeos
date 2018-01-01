################################################################################
#
# libsndfile
#
################################################################################

LIBSNDFILE_VERSION = 1.0.28
LIBSNDFILE_SITE = http://www.mega-nerd.com/libsndfile/files
LIBSNDFILE_INSTALL_STAGING = YES
LIBSNDFILE_LICENSE = LGPL-2.1+
LIBSNDFILE_LICENSE_FILES = COPYING

LIBSNDFILE_CONF_OPTS = \
	--disable-sqlite \
	--disable-alsa \
	--disable-external-libs \
	--disable-full-suite

$(eval $(autotools-package))
