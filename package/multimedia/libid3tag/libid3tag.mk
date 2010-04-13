#############################################################
#
# libid3tag
#
#############################################################

LIBID3TAG_VERSION:=0.15.1b
LIBID3TAG_SOURCE:=libid3tag-$(LIBID3TAG_VERSION).tar.gz
LIBID3TAG_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mad
LIBID3TAG_INSTALL_STAGING=YES
LIBID3TAG_DEPENDENCIES=zlib
LIBID3TAG_LIBTOOL_PATCH=NO

$(eval $(call AUTOTARGETS,package/multimedia,libid3tag))
