################################################################################
#
# tovid
#
################################################################################

TOVID_SITE = http://tovid.googlecode.com/svn/trunk/tovid
TOVID_SITE_METHOD = svn
TOVID_VERSION = 3534
TOVID_LICENSE = GPLv2+
TOVID_LICENSE_FILES = COPYING
TOVID_SETUP_TYPE = distutils

$(eval $(python-package))
