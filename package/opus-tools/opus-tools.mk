################################################################################
#
# opus-tools
#
################################################################################

OPUS_TOOLS_VERSION = 0.1.6
OPUS_TOOLS_SITE = http://downloads.xiph.org/releases/opus
OPUS_TOOLS_CONF_OPT = --disable-oggtest --disable-opustest
OPUS_TOOLS_DEPENDENCIES = opus libogg host-pkgconf

ifeq ($(BR2_PACKAGE_LIBPCAP),y)
OPUS_TOOLS_DEPENDENCIES += libpcap
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
OPUS_TOOLS_CONF_OPT += --enable-sse
else
OPUS_TOOLS_CONF_OPT += --disable-sse
endif

$(eval $(autotools-package))
