################################################################################
#
# bayer2rgb-neon
#
################################################################################

BAYER2RGB_NEON_VERSION = v0.4
BAYER2RGB_NEON_SOURCE = bayer2rgb-neon-$(BAYER2RGB_NEON_VERSION).tar.bz2
BAYER2RGB_NEON_SITE = https://git.phytec.de/bayer2rgb-neon/snapshot
BAYER2RGB_NEON_LICENSE = GPL-3.0
BAYER2RGB_NEON_LICENSE_FILES = COPYING
BAYER2RGB_NEON_INSTALL_STAGING = YES
BAYER2RGB_NEON_DEPENDENCIES = host-pkgconf host-gengetopt
BAYER2RGB_NEON_AUTORECONF = YES

BAYER2RGB_NEON_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -mfpu=neon"

define BAYER2RGB_NEON_PRE_CONFIGURE_FIXUP
	mkdir -p $(@D)/m4
endef

BAYER2RGB_NEON_PRE_CONFIGURE_HOOKS += BAYER2RGB_NEON_PRE_CONFIGURE_FIXUP

$(eval $(autotools-package))
