################################################################################
#
# python-mock
#
################################################################################

PYTHON_MOCK_VERSION = 2.0.0
PYTHON_MOCK_SOURCE = mock-$(PYTHON_MOCK_VERSION).tar.gz
PYTHON_MOCK_SITE = https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f
PYTHON_MOCK_SETUP_TYPE = setuptools
PYTHON_MOCK_LICENSE = Apache-2.0
PYTHON_MOCK_LICENSE_FILES = LICENSE.txt
PYTHON_MOCK_DEPENDENCIES = host-python-pbr

$(eval $(python-package))
