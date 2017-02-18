################################################################################
#
# python-singledispatch
#
################################################################################

PYTHON_SINGLEDISPATCH_VERSION = 3.4.0.3
PYTHON_SINGLEDISPATCH_SOURCE = singledispatch-$(PYTHON_SINGLEDISPATCH_VERSION).tar.gz
PYTHON_SINGLEDISPATCH_SITE = https://pypi.python.org/packages/source/s/singledispatch
PYTHON_SINGLEDISPATCH_LICENSE = MIT
PYTHON_SINGLEDISPATCH_LICENSE_FILES = setup.py
PYTHON_SINGLEDISPATCH_SETUP_TYPE = setuptools

$(eval $(python-package))
