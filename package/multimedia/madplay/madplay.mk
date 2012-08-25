#############################################################
#
# madplay
#
#############################################################
MADPLAY_VERSION:=0.15.2b
MADPLAY_SOURCE:=madplay-$(MADPLAY_VERSION).tar.gz
MADPLAY_SITE:=http://downloads.sourceforge.net/project/mad/madplay/$(MADPLAY_VERSION)
MADPLAY_LIBTOOL_PATCH=NO
MADPLAY_DEPENDENCIES=libmad libid3tag

# Check if ALSA is built, then we should configure after alsa-lib so
# ./configure can find alsa-lib.
ifeq ($(BR2_PACKAGE_MADPLAY_ALSA),y)
MADPLAY_CONF_OPT+=--with-alsa
MADPLAY_DEPENDENCIES+=alsa-lib
endif

$(eval $(autotools-package))
