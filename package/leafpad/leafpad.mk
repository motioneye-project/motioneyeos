#############################################################
#
# leafpad
#
#############################################################
LEAFPAD_VERSION = 0.8.14
LEAFPAD_SOURCE = leafpad-$(LEAFPAD_VERSION).tar.gz
LEAFPAD_SITE = http://savannah.nongnu.org/download/leafpad
LEAFPAD_AUTORECONF = NO
LEAFPAD_INSTALL_STAGING = NO
LEAFPAD_INSTALL_TARGET = YES

LEAFPAD_DEPENDENCIES = uclibc libgtk2

$(eval $(call AUTOTARGETS,package,leafpad))

