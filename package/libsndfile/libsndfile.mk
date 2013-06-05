################################################################################
#
# libsndfile
#
################################################################################

LIBSNDFILE_VERSION = 1.0.25
LIBSNDFILE_SITE = http://www.mega-nerd.com/libsndfile/files
LIBSNDFILE_INSTALL_STAGING = YES

$(eval $(autotools-package))
