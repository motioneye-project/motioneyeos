################################################################################
#
# proj
#
################################################################################

PROJ_VERSION = 4.9.3
PROJ_SITE = http://download.osgeo.org/proj
PROJ_LICENSE = MIT
PROJ_LICENSE_FILES = COPYING
PROJ_INSTALL_STAGING = YES

$(eval $(autotools-package))
