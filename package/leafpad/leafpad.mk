################################################################################
#
# leafpad
#
################################################################################

LEAFPAD_VERSION = 0.8.18
LEAFPAD_SITE = http://savannah.nongnu.org/download/leafpad
LEAFPAD_DEPENDENCIES = libgtk2 host-intltool
LEAFPAD_LICENSE = GPLv2+
LEAFPAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
