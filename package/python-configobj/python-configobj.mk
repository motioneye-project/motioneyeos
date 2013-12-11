################################################################################
#
# python-configobj
#
################################################################################

PYTHON_CONFIGOBJ_VERSION = 4.7.2
PYTHON_CONFIGOBJ_SOURCE = configobj-$(PYTHON_CONFIGOBJ_VERSION).tar.gz
PYTHON_CONFIGOBJ_SITE = http://pypi.python.org/packages/source/c/configobj
PYTHON_CONFIGOBJ_LICENSE = BSD-3c
# License only mentioned in the source
PYTHON_CONFIGOBJ_SETUP_TYPE = distutils

$(eval $(python-package))
