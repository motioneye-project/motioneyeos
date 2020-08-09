################################################################################
#
# python-pathpy
#
################################################################################

PYTHON_PATHPY_VERSION = 12.0.1
PYTHON_PATHPY_SOURCE = path.py-$(PYTHON_PATHPY_VERSION).tar.gz
PYTHON_PATHPY_SITE = https://files.pythonhosted.org/packages/70/63/c01c1bb2df17db4c78f78cc439a2800f55bec5445cabf1f3579a37909f41
PYTHON_PATHPY_SETUP_TYPE = setuptools
PYTHON_PATHPY_LICENSE = MIT
PYTHON_PATHPY_LICENSE_FILES = LICENSE
PYTHON_PATHPY_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
