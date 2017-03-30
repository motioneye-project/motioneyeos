################################################################################
#
# libcue
#
################################################################################

LIBCUE_VERSION = v1.4.0
LIBCUE_SITE = $(call github,lipnitsk,libcue,$(LIBCUE_VERSION))
LIBCUE_LICENSE = GPL-2.0, BSD-2-Clause (rem.c)
LIBCUE_LICENSE_FILES = COPYING
LIBCUE_DEPENDENCIES = host-bison host-flex flex
LIBCUE_INSTALL_STAGING = YES
LIBCUE_AUTORECONF = YES

# Needed for autoreconf
define LIBCUE_MAKE_CONFIG_DIR
	mkdir $(@D)/config
endef
LIBCUE_POST_EXTRACT_HOOKS += LIBCUE_MAKE_CONFIG_DIR

$(eval $(autotools-package))
