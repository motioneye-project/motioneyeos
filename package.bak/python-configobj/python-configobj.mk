################################################################################
#
# python-configobj
#
################################################################################

PYTHON_CONFIGOBJ_VERSION = 5.0.6
PYTHON_CONFIGOBJ_SOURCE = configobj-$(PYTHON_CONFIGOBJ_VERSION).tar.gz
PYTHON_CONFIGOBJ_SITE = https://pypi.python.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab
PYTHON_CONFIGOBJ_LICENSE = BSD-3c
# License only mentioned in the source
PYTHON_CONFIGOBJ_SETUP_TYPE = distutils

$(eval $(python-package))
