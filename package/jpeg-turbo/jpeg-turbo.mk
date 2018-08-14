################################################################################
#
# jpeg-turbo
#
################################################################################

JPEG_TURBO_VERSION = 2.0.0
JPEG_TURBO_SOURCE = libjpeg-turbo-$(JPEG_TURBO_VERSION).tar.gz
JPEG_TURBO_SITE = https://downloads.sourceforge.net/project/libjpeg-turbo/$(JPEG_TURBO_VERSION)
JPEG_TURBO_LICENSE = IJG (libjpeg), BSD-3-Clause (TurboJPEG), Zlib (SIMD)
JPEG_TURBO_LICENSE_FILES = LICENSE.md README.ijg
JPEG_TURBO_INSTALL_STAGING = YES
JPEG_TURBO_PROVIDES = jpeg
JPEG_TURBO_DEPENDENCIES = host-pkgconf

JPEG_TURBO_CONF_OPTS = -DWITH_JPEG8=ON

ifeq ($(BR2_PACKAGE_JPEG_SIMD_SUPPORT),y)
JPEG_TURBO_CONF_OPTS += -DWITH_SIMD=ON
# x86 simd support needs nasm
JPEG_TURBO_DEPENDENCIES += $(if $(BR2_X86_CPU_HAS_MMX),host-nasm)
else
JPEG_TURBO_CONF_OPTS += -DWITH_SIMD=OFF
endif

define JPEG_TURBO_REMOVE_USELESS_TOOLS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,cjpeg djpeg jpegtran rdjpgcom tjbench wrjpgcom)
endef

JPEG_TURBO_POST_INSTALL_TARGET_HOOKS += JPEG_TURBO_REMOVE_USELESS_TOOLS

$(eval $(cmake-package))
