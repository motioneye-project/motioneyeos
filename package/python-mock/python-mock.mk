################################################################################
#
# python-mock
#
################################################################################

PYTHON_MOCK_VERSION = 3.0.5
PYTHON_MOCK_SOURCE = mock-$(PYTHON_MOCK_VERSION).tar.gz
PYTHON_MOCK_SITE = https://files.pythonhosted.org/packages/2e/ab/4fe657d78b270aa6a32f027849513b829b41b0f28d9d8d7f8c3d29ea559a
PYTHON_MOCK_SETUP_TYPE = setuptools
PYTHON_MOCK_LICENSE = Apache-2.0
PYTHON_MOCK_LICENSE_FILES = LICENSE.txt
PYTHON_MOCK_DEPENDENCIES = host-python-pbr

$(eval $(python-package))
