################################################################################
#
# spandsp
#
################################################################################

SPANDSP_VERSION = 20180108
SPANDSP_SITE = https://www.soft-switch.org/downloads/spandsp/snapshots

SPANDSP_LICENSE = LGPL-2.1 (library), GPL-2.0 (test suite)
SPANDSP_LICENSE_FILES = COPYING

SPANDSP_DEPENDENCIES = tiff host-pkgconf
SPANDSP_INSTALL_STAGING = YES
SPANDSP_CONF_ENV = LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs libtiff-4`"

SPANDSP_CONF_OPTS = \
	--disable-builtin-tiff \
	$(if $(BR2_X86_CPU_HAS_MMX),--enable-mmx,--disable-mmx) \
	$(if $(BR2_X86_CPU_HAS_SSE),--enable-sse,--disable-sse) \
	$(if $(BR2_X86_CPU_HAS_SSE2),--enable-sse2,--disable-sse2) \
	$(if $(BR2_X86_CPU_HAS_SSE3),--enable-sse3,--disable-sse3) \
	$(if $(BR2_X86_CPU_HAS_SSSE3),--enable-ssse3,--disable-ssse3) \
	$(if $(BR2_X86_CPU_HAS_SSE4),--enable-sse4-1,--disable-sse4-1) \
	$(if $(BR2_X86_CPU_HAS_SSE42),--enable-sse4-2,--disable-sse4-2)

$(eval $(autotools-package))
