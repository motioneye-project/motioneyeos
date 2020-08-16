################################################################################
#
# bayer2rgb-neon
#
################################################################################

BAYER2RGB_NEON_VERSION = bef3ecafe290d61a50fd27da3e5d0df6f4b88045
BAYER2RGB_NEON_SITE = https://gitlab-ext.sigma-chemnitz.de/ensc/bayer2rgb.git
BAYER2RGB_NEON_SITE_METHOD = git
BAYER2RGB_NEON_LICENSE = GPL-3.0
BAYER2RGB_NEON_LICENSE_FILES = COPYING
BAYER2RGB_NEON_INSTALL_STAGING = YES
BAYER2RGB_NEON_DEPENDENCIES = host-pkgconf host-gengetopt
BAYER2RGB_NEON_AUTORECONF = YES

BAYER2RGB_NEON_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -mfpu=neon"

$(eval $(autotools-package))
