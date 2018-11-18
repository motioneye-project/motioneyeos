################################################################################
#
# python-pydal
#
################################################################################

PYTHON_PYDAL_VERSION = 17.11
PYTHON_PYDAL_SOURCE = pyDAL-$(PYTHON_PYDAL_VERSION).tar.gz
PYTHON_PYDAL_SITE = https://files.pythonhosted.org/packages/d2/64/a119cb70ed91a6273aad811fd250b8a55d4bc8b0d900757723ec5a4f0ba9
PYTHON_PYDAL_LICENSE = BSD-3-Clause
PYTHON_PYDAL_LICENSE_FILES = LICENSE
PYTHON_PYDAL_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
