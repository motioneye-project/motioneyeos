################################################################################
#
# python-pip
#
################################################################################

PYTHON_PIP_VERSION = 19.1
PYTHON_PIP_SOURCE = pip-$(PYTHON_PIP_VERSION).tar.gz
PYTHON_PIP_SITE = https://files.pythonhosted.org/packages/51/5f/802a04274843f634469ef299fcd273de4438386deb7b8681dd059f0ee3b7
PYTHON_PIP_SETUP_TYPE = setuptools
PYTHON_PIP_LICENSE = MIT
PYTHON_PIP_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
