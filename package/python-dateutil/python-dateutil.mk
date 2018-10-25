################################################################################
#
# python-dateutil
#
################################################################################

PYTHON_DATEUTIL_VERSION = 2.7.4
PYTHON_DATEUTIL_SITE = https://files.pythonhosted.org/packages/a5/15/37f2e39504a98ec4b3eba8c9a61755dd5374388201ee60d1ae5b8e7a3d09
PYTHON_DATEUTIL_SETUP_TYPE = setuptools
PYTHON_DATEUTIL_LICENSE = BSD-3-Clause
PYTHON_DATEUTIL_LICENSE_FILES = LICENSE
PYTHON_DATEUTIL_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
