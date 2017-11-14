################################################################################
#
# python-treq
#
################################################################################

PYTHON_TREQ_VERSION = 17.8.0
PYTHON_TREQ_SOURCE = treq-$(PYTHON_TREQ_VERSION).tar.gz
PYTHON_TREQ_SITE = https://pypi.python.org/packages/11/3e/1014f26bfd4d07db015ad48384446b3bdc4de4bbdd2eba3be7fbb149cc44
PYTHON_TREQ_LICENSE = MIT
PYTHON_TREQ_LICENSE_FILES = LICENSE
PYTHON_TREQ_SETUP_TYPE = setuptools
PYTHON_TREQ_DEPENDENCIES = host-python-incremental

$(eval $(python-package))
