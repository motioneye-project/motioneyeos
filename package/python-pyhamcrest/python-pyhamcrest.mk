################################################################################
#
# python-pyhamcrest
#
################################################################################

PYTHON_PYHAMCREST_VERSION = 1.9.0
PYTHON_PYHAMCREST_SOURCE = PyHamcrest-$(PYTHON_PYHAMCREST_VERSION).tar.gz
PYTHON_PYHAMCREST_SITE = https://files.pythonhosted.org/packages/a4/89/a469aad9256aedfbb47a29ec2b2eeb855d9f24a7a4c2ff28bd8d1042ef02
PYTHON_PYHAMCREST_SETUP_TYPE = setuptools
PYTHON_PYHAMCREST_LICENSE = BSD-3-Clause
PYTHON_PYHAMCREST_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
