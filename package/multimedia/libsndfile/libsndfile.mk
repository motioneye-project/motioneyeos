#############################################################
#
# libsndfile
#
#############################################################
LIBSNDFILE_VERSION:=1.0.18
LIBSNDFILE_SOURCE:=libsndfile-$(LIBSNDFILE_VERSION).tar.gz
LIBSNDFILE_SITE:=http://www.mega-nerd.com/libsndfile
LIBSNDFILE_LIBTOOL_PATCH:=NO
LIBSNDFILE_INSTALL_STAGING:=YES
LIBSNDFILE_DEPENDENCIES:=uclibc

$(eval $(call AUTOTARGETS,package/multimedia,libsndfile))
