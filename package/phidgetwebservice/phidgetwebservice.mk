################################################################################
#
# phidgetwebservice
#
################################################################################

PHIDGETWEBSERVICE_VERSION = 2.1.8.20140319
PHIDGETWEBSERVICE_SOURCE = phidgetwebservice_$(PHIDGETWEBSERVICE_VERSION).tar.gz
PHIDGETWEBSERVICE_SITE = http://www.phidgets.com/downloads/libraries
PHIDGETWEBSERVICE_DEPENDENCIES = libphidget
PHIDGETWEBSERVICE_LICENSE = LGPLv3
PHIDGETWEBSERVICE_LICENSE_FILES = COPYING

$(eval $(autotools-package))
