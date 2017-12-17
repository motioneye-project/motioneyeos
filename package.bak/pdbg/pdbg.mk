################################################################################
#
# pdbg
#
################################################################################

PDBG_VERSION = 90a7370a11e727f1482dea6ff2bd6aec20c64805
PDBG_SITE = $(call github,open-power,pdbg,$(PDBG_VERSION))
PDBG_LICENSE = Apache 2.0
PDBG_LICENSE_FILES = COPYING
PDBG_AUTORECONF = YES

$(eval $(autotools-package))
