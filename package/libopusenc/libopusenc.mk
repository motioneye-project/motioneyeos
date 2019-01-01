################################################################################
#
# libopusenc
#
################################################################################

LIBOPUSENC_VERSION = 0.2.1
LIBOPUSENC_SITE = https://downloads.xiph.org/releases/opus
LIBOPUSENC_LICENSE = BSD-3-Clause
LIBOPUSENC_LICENSE_FILES = COPYING
LIBOPUSENC_INSTALL_STAGING = YES
LIBOPUSENC_DEPENDENCIES = host-pkgconf opus

LIBOPUSENC_CONF_OPTS = --disable-examples

$(eval $(autotools-package))
