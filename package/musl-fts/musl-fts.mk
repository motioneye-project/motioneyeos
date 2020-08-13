################################################################################
#
# musl-fts
#
################################################################################

MUSL_FTS_VERSION = 1.2.7
MUSL_FTS_SITE = $(call github,void-linux,musl-fts,v$(MUSL_FTS_VERSION))
MUSL_FTS_AUTORECONF = YES
MUSL_FTS_LICENSE = BSD-3-Clause
MUSL_FTS_LICENSE_FILES = COPYING
# pkg-config needed for autoreconf
MUSL_FTS_DEPENDENCIES = host-pkgconf
MUSL_FTS_INSTALL_STAGING = YES

$(eval $(autotools-package))
