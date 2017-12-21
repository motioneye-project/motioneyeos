################################################################################
#
# iotop
#
################################################################################

IOTOP_VERSION = 0.6
IOTOP_SITE = http://guichaz.free.fr/iotop/files
IOTOP_LICENSE = GPL-2.0+
IOTOP_LICENSE_FILES = COPYING
IOTOP_SETUP_TYPE = distutils

$(eval $(python-package))
