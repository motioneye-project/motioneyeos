################################################################################
#
# python-treq
#
################################################################################

PYTHON_TREQ_VERSION = 15.1.0
PYTHON_TREQ_SOURCE = treq-$(PYTHON_TREQ_VERSION).tar.gz
PYTHON_TREQ_SITE = http://pypi.python.org/packages/source/t/treq
PYTHON_TREQ_LICENSE = MIT
PYTHON_TREQ_LICENSE_FILES = LICENSE
PYTHON_TREQ_SETUP_TYPE = setuptools

$(eval $(python-package))
