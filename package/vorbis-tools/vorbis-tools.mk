################################################################################
#
# vorbis-tools
#
################################################################################

VORBIS_TOOLS_VERSION = 1.4.0
VORBIS_TOOLS_SITE = http://downloads.xiph.org/releases/vorbis
VORBIS_TOOLS_LICENSE = GPL-2.0
VORBIS_TOOLS_LICENSE_FILES = COPYING
VORBIS_TOOLS_DEPENDENCIES = libao libogg libvorbis libcurl
VORBIS_TOOLS_CONF_OPTS = --program-transform-name=''
# ogg123 calls math functions but forgets to link with libm
VORBIS_TOOLS_CONF_ENV = LIBS=-lm

ifeq ($(BR2_PACKAGE_FLAC),y)
VORBIS_TOOLS_DEPENDENCIES += flac
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
VORBIS_TOOLS_DEPENDENCIES += speex
endif

$(eval $(autotools-package))
