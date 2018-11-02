################################################################################
#
# python-pip
#
################################################################################

PYTHON_PIP_VERSION = 18.1
PYTHON_PIP_SOURCE = pip-$(PYTHON_PIP_VERSION).tar.gz
PYTHON_PIP_SITE = https://files.pythonhosted.org/packages/45/ae/8a0ad77defb7cc903f09e551d88b443304a9bd6e6f124e75c0fbbf6de8f7
PYTHON_PIP_SETUP_TYPE = setuptools
PYTHON_PIP_LICENSE = MIT
PYTHON_PIP_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
