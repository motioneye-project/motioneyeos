#############################################################
#
# libraw1394
#
#############################################################
LIBRAW1394_VERSION:=1.2.1
LIBRAW1394_SOURCE:=libraw1394-$(LIBRAW1394_VERSION).tar.gz
LIBRAW1394_SITE:=http://www.kernel.org/pub/linux/libs/ieee1394/
LIBRAW1394_INSTALL_STAGING=YES

$(eval $(call AUTOTARGETS,package,libraw1394))
