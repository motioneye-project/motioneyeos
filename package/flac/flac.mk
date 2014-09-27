################################################################################
#
# flac
#
################################################################################

FLAC_VERSION = 1.3.0
FLAC_SITE = http://downloads.xiph.org/releases/flac
FLAC_SOURCE = flac-$(FLAC_VERSION).tar.xz
FLAC_INSTALL_STAGING = YES
FLAC_AUTORECONF = YES
FLAC_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)
FLAC_LICENSE = Xiph BSD-like (libFLAC), GPLv2+ (tools), LGPLv2.1+ (other libraries)
FLAC_LICENSE_FILES = COPYING.Xiph COPYING.GPL COPYING.LGPL
FLAC_CONF_OPTS = \
	--disable-cpplibs \
	--disable-xmms-plugin \
	--disable-altivec

ifeq ($(BR2_PACKAGE_LIBOGG),y)
FLAC_CONF_OPTS += --with-ogg=$(STAGING_DIR)/usr
FLAC_DEPENDENCIES += libogg
else
FLAC_CONF_OPTS += --disable-ogg
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
FLAC_DEPENDENCIES += host-nasm
FLAC_CONF_OPTS += --enable-sse
else
FLAC_CONF_OPTS += --disable-sse
endif

$(eval $(autotools-package))
