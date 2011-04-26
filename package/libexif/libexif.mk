#############################################################
#
# libexif
#
#############################################################

LIBEXIF_VERSION = 0.6.20
LIBEXIF_SOURCE = libexif-$(LIBEXIF_VERSION).tar.bz2
LIBEXIF_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/libexif/libexif/$(LIBEXIF_VERSION)
LIBEXIF_INSTALL_STAGING = YES
LIBEXIF_CONF_OPT = --disable-docs
LIBEXIF_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS,package,libexif))
