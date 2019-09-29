################################################################################
#
# python-pathlib2
#
################################################################################

PYTHON_PATHLIB2_VERSION = 2.3.3
PYTHON_PATHLIB2_SOURCE = pathlib2-$(PYTHON_PATHLIB2_VERSION).tar.gz
PYTHON_PATHLIB2_SITE = https://files.pythonhosted.org/packages/bf/d7/a2568f4596b75d2c6e2b4094a7e64f620decc7887f69a1f2811931ea15b9
PYTHON_PATHLIB2_LICENSE = MIT
PYTHON_PATHLIB2_LICENSE_FILES = LICENSE.rst
PYTHON_PATHLIB2_SETUP_TYPE = setuptools

$(eval $(python-package))
