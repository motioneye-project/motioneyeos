################################################################################
#
# python-py
#
################################################################################

PYTHON_PY_VERSION = 1.8.1
PYTHON_PY_SOURCE = py-$(PYTHON_PY_VERSION).tar.gz
PYTHON_PY_SITE = https://files.pythonhosted.org/packages/bd/8f/169d08dcac7d6e311333c96b63cbe92e7947778475e1a619b674989ba1ed
PYTHON_PY_DEPENDENCIES = host-python-setuptools-scm
PYTHON_PY_SETUP_TYPE = setuptools
PYTHON_PY_LICENSE = MIT
PYTHON_PY_LICENSE_FILES = LICENSE

$(eval $(python-package))
