################################################################################
#
# enchant
#
################################################################################

ENCHANT_VERSION = 1.6.0
ENCHANT_SITE = http://www.abisource.com/downloads/enchant/$(ENCHANT_VERSION)
ENCHANT_INSTALL_STAGING = YES
ENCHANT_DEPENDENCIES = libglib2 host-pkgconf
ENCHANT_LICENSE = LGPLv2.1+
ENCHANT_LICENSE_FILES = COPYING.LIB

$(eval $(autotools-package))
