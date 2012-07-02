#############################################################
#
# enchant
#
#############################################################
ENCHANT_VERSION = 1.5.0
ENCHANT_SOURCE = enchant-$(ENCHANT_VERSION).tar.gz
ENCHANT_SITE = http://www.abisource.com/downloads/enchant/$(ENCHANT_VERSION)
ENCHANT_INSTALL_STAGING = YES
ENCHANT_DEPENDENCIES = libglib2 host-pkg-config

$(eval $(autotools-package))
