################################################################################
#
# python-dateutil
#
################################################################################

PYTHON_DATEUTIL_VERSION = 2.7.5
PYTHON_DATEUTIL_SITE = https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0
PYTHON_DATEUTIL_SETUP_TYPE = setuptools
PYTHON_DATEUTIL_LICENSE = BSD-3-Clause
PYTHON_DATEUTIL_LICENSE_FILES = LICENSE
PYTHON_DATEUTIL_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
