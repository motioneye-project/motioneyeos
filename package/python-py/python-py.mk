################################################################################
#
# python-py
#
################################################################################

PYTHON_PY_VERSION = 1.7.0
PYTHON_PY_SOURCE = py-$(PYTHON_PY_VERSION).tar.gz
PYTHON_PY_SITE = https://files.pythonhosted.org/packages/c7/fa/eb6dd513d9eb13436e110aaeef9a1703437a8efa466ce6bb2ff1d9217ac7
PYTHON_PY_DEPENDENCIES = host-python-setuptools-scm
PYTHON_PY_SETUP_TYPE = setuptools
PYTHON_PY_LICENSE = MIT
PYTHON_PY_LICENSE_FILES = LICENSE

$(eval $(python-package))
