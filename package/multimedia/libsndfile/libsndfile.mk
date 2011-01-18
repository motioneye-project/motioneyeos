#############################################################
#
# libsndfile
#
#############################################################

LIBSNDFILE_VERSION = 1.0.23
LIBSNDFILE_SITE = http://www.mega-nerd.com/libsndfile/files
LIBSNDFILE_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package/multimedia,libsndfile))
