################################################################################
#
# python-pyroute2
#
################################################################################

PYTHON_PYROUTE2_VERSION = 0.5.3
PYTHON_PYROUTE2_SOURCE = pyroute2-$(PYTHON_PYROUTE2_VERSION).tar.gz
PYTHON_PYROUTE2_SITE =  https://files.pythonhosted.org/packages/19/1c/fc2efd9dfa5c1f7f713dbfee621365ad01f7b7ec0a6908e444f08bfd5873
PYTHON_PYROUTE2_LICENSE = Apache-2.0 or GPL-2.0+
PYTHON_PYROUTE2_LICENSE_FILES = LICENSE.Apache.v2 LICENSE.GPL.v2 README.license.md
PYTHON_PYROUTE2_SETUP_TYPE = distutils

$(eval $(python-package))
