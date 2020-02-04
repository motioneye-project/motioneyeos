################################################################################
#
# pdbg
#
################################################################################

PDBG_VERSION = 2.4
PDBG_SITE = $(call github,open-power,pdbg,v$(PDBG_VERSION))
PDBG_LICENSE = Apache-2.0
PDBG_LICENSE_FILES = COPYING
PDBG_AUTORECONF = YES
PDBG_DEPENDENCIES = host-dtc

PDBG_MAKE_OPTS = "GIT_SHA1=\"v$(PDBG_VERSION)\""

$(eval $(autotools-package))
