################################################################################
#
# libcue
#
################################################################################

LIBCUE_VERSION = 1.4.0
LIBCUE_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libcue
LIBCUE_SOURCE = libcue-$(LIBCUE_VERSION).tar.bz2
LIBCUE_DEPENDENCIES = flex
LIBCUE_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package/multimedia,libcue))
