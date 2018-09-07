################################################################################
#
# python-pip
#
################################################################################

PYTHON_PIP_VERSION = 18.0
PYTHON_PIP_SOURCE = pip-$(PYTHON_PIP_VERSION).tar.gz
PYTHON_PIP_SITE = https://files.pythonhosted.org/packages/69/81/52b68d0a4de760a2f1979b0931ba7889202f302072cc7a0d614211bc7579
PYTHON_PIP_SETUP_TYPE = setuptools
PYTHON_PIP_LICENSE = MIT
PYTHON_PIP_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
