################################################################################
#
# leafpad
#
################################################################################

LEAFPAD_VERSION = 0.8.18.1
LEAFPAD_SITE = http://savannah.nongnu.org/download/leafpad
LEAFPAD_DEPENDENCIES = libgtk2 host-intltool
LEAFPAD_LICENSE = GPL-2.0+
LEAFPAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
