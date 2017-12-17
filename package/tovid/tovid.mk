################################################################################
#
# tovid
#
################################################################################

TOVID_VERSION = 0.35.2
TOVID_SITE = https://github.com/tovid-suite/tovid/releases/download/$(TOVID_VERSION)
TOVID_LICENSE = GPL-2.0+
TOVID_LICENSE_FILES = COPYING
TOVID_SETUP_TYPE = distutils

$(eval $(python-package))
