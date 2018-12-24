################################################################################
#
# brcm-patchram-plus
#
################################################################################

BRCM_PATCHRAM_PLUS_VERSION = 94fb127e614b19a9a95561b8c1a0716e2e1e6293
BRCM_PATCHRAM_PLUS_SITE = $(call github,AsteroidOS,brcm-patchram-plus,$(BRCM_PATCHRAM_PLUS_VERSION))
BRCM_PATCHRAM_PLUS_LICENSE = Apache-2.0
BRCM_PATCHRAM_PLUS_LICENSE_FILES = src/main.c
BRCM_PATCHRAM_PLUS_AUTORECONF = YES

$(eval $(autotools-package))
