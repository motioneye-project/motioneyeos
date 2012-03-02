#############################################################
#
# leafpad
#
#############################################################
LEAFPAD_VERSION = 0.8.18
LEAFPAD_SOURCE = leafpad-$(LEAFPAD_VERSION).tar.gz
LEAFPAD_SITE = http://savannah.nongnu.org/download/leafpad
LEAFPAD_INSTALL_TARGET = YES

LEAFPAD_DEPENDENCIES = libgtk2

$(eval $(call AUTOTARGETS))

