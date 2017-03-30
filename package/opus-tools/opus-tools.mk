################################################################################
#
# opus-tools
#
################################################################################

OPUS_TOOLS_VERSION = 0.1.9
OPUS_TOOLS_SITE = http://downloads.xiph.org/releases/opus
OPUS_TOOLS_LICENSE = BSD-2-Clause
OPUS_TOOLS_LICENSE_FILES = COPYING
OPUS_TOOLS_CONF_OPTS = --disable-oggtest --disable-opustest
OPUS_TOOLS_DEPENDENCIES = opus libogg host-pkgconf

ifeq ($(BR2_PACKAGE_LIBPCAP),y)
OPUS_TOOLS_DEPENDENCIES += libpcap
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
OPUS_TOOLS_CONF_OPTS += --enable-sse
else
OPUS_TOOLS_CONF_OPTS += --disable-sse
endif

ifeq ($(BR2_PACKAGE_FLAC),y)
OPUS_TOOLS_DEPENDENCIES += flac
else
OPUS_TOOLS_CONF_OPTS += --without-flac
endif

$(eval $(autotools-package))
