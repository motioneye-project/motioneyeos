################################################################################
#
# pdbg
#
################################################################################

PDBG_VERSION = 2.2
PDBG_SITE = $(call github,open-power,pdbg,v$(PDBG_VERSION))
PDBG_LICENSE = Apache-2.0
PDBG_LICENSE_FILES = COPYING
PDBG_AUTORECONF = YES
PDBG_DEPENDENCIES = host-dtc

PDBG_MAKE_OPTS = "GIT_SHA1=\"v$(PDBG_VERSION)\""

define PDBG_PATCH_M4
	mkdir -p $(@D)/m4
endef
PDBG_POST_PATCH_HOOKS += PDBG_PATCH_M4

$(eval $(autotools-package))
