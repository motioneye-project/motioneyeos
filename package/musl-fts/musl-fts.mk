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

define MUSL_FTS_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef
MUSL_FTS_POST_PATCH_HOOKS += MUSL_FTS_CREATE_M4_DIR

$(eval $(autotools-package))
