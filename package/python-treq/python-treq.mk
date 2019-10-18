################################################################################
#
# python-treq
#
################################################################################

PYTHON_TREQ_VERSION = 18.6.0
PYTHON_TREQ_SOURCE = treq-$(PYTHON_TREQ_VERSION).tar.gz
PYTHON_TREQ_SITE = https://pypi.python.org/packages/cb/c5/c83628d7e1a5d62a71eab0a5d1cdcdc53b49ead873f52975457ff2a8ae21
PYTHON_TREQ_LICENSE = MIT
PYTHON_TREQ_LICENSE_FILES = LICENSE
PYTHON_TREQ_SETUP_TYPE = setuptools
PYTHON_TREQ_DEPENDENCIES = host-python-incremental

$(eval $(python-package))
