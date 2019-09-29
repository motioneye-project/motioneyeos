################################################################################
#
# brcm-patchram-plus
#
################################################################################

BRCM_PATCHRAM_PLUS_VERSION = 95b7b6916d661a4da3f9c0adf52d5e1f4f8ab042
BRCM_PATCHRAM_PLUS_SITE = $(call github,AsteroidOS,brcm-patchram-plus,$(BRCM_PATCHRAM_PLUS_VERSION))
BRCM_PATCHRAM_PLUS_LICENSE = Apache-2.0
BRCM_PATCHRAM_PLUS_LICENSE_FILES = COPYING
BRCM_PATCHRAM_PLUS_AUTORECONF = YES

$(eval $(autotools-package))
