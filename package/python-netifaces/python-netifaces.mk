################################################################################
#
# python-netifaces
#
################################################################################

PYTHON_NETIFACES_VERSION = 0.7
PYTHON_NETIFACES_SOURCE  = netifaces-$(PYTHON_NETIFACES_VERSION).tar.gz
PYTHON_NETIFACES_SITE    = http://alastairs-place.net/projects/netifaces
PYTHON_NETIFACES_LICENSE = MIT
PYTHON_NETIFACES_LICENSE_FILES = README
PYTHON_NETIFACES_SETUP_TYPE = setuptools

$(eval $(python-package))
