#############################################################
#
# divine
#
#############################################################

DIVINE_VERSION := 0.4.0
DIVINE_SITE := http://www.directfb.org/downloads/Extras
DIVINE_SOURCE = DiVine-$(DIVINE_VERSION).tar.gz
DIVINE_INSTALL_STAGING = YES
DIVINE_INSTALL_TARGET = YES
DIVINE_DEPENDENCIES = directfb

$(eval $(call AUTOTARGETS,package,divine))
