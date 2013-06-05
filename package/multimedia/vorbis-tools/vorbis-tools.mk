################################################################################
#
# vorbis-tools
#
################################################################################

VORBIS_TOOLS_VERSION = 1.4.0
VORBIS_TOOLS_SITE = http://downloads.xiph.org/releases/vorbis
VORBIS_TOOLS_DEPENDENCIES = libao libogg libvorbis libcurl
VORBIS_TOOLS_CONF_OPT = --program-transform-name=''

ifeq ($(BR2_PACKAGE_FLAC),y)
VORBIS_TOOLS_DEPENDENCIES += flac
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
VORBIS_TOOLS_DEPENDENCIES += speex
endif

$(eval $(autotools-package))
