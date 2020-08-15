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

# 0001-oggenc-Fix-large-alloca-on-bad-AIFF-input.patch
VORBIS_TOOLS_IGNORE_CVES += CVE-2015-6749
# 0002-oggenc-validate-count-of-channels-in-the-header-CVE-.patch
VORBIS_TOOLS_IGNORE_CVES += CVE-2014-9638 CVE-2014-9639
# 0003-oggenc-fix-crash-on-raw-file-close-reported-by-Hanno.patch
VORBIS_TOOLS_IGNORE_CVES += CVE-2014-9640

# ogg123 calls math functions but forgets to link with libm
VORBIS_TOOLS_CONF_ENV = LIBS=-lm

ifeq ($(BR2_PACKAGE_FLAC),y)
VORBIS_TOOLS_DEPENDENCIES += flac
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
VORBIS_TOOLS_DEPENDENCIES += speex
endif

$(eval $(autotools-package))
