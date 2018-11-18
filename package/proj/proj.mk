################################################################################
#
# proj
#
################################################################################

PROJ_VERSION = 5.0.1
PROJ_SITE = http://download.osgeo.org/proj
PROJ_LICENSE = MIT
PROJ_LICENSE_FILES = COPYING
PROJ_INSTALL_STAGING = YES

$(eval $(autotools-package))
