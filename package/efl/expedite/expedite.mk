#############################################################
#
# expedite
#
#############################################################

EXPEDITE_VERSION = 1.1.0
EXPEDITE_SITE = http://download.enlightenment.org/releases/
EXPEDITE_LICENSE = BSD-2c
EXPEDITE_LICENSE_FILES = COPYING

EXPEDITE_DEPENDENCIES = libevas libeina libeet

$(eval $(autotools-package))
