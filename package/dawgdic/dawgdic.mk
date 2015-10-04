################################################################################
#
# dawgdic
#
################################################################################

DAWGDIC_VERSION = 16ac537ba9883ff01b63b6d1fdc3072150c68fee
DAWGDIC_SITE = $(call github,stil,dawgdic,$(DAWGDIC_VERSION))
DAWGDIC_LICENSE = BSD-3c
DAWGDIC_LICENSE_FILES = COPYING
DAWGDIC_AUTORECONF = YES
DAWGDIC_INSTALL_STAGING = YES

$(eval $(autotools-package))
