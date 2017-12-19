################################################################################
#
# python-dateutil
#
################################################################################

PYTHON_DATEUTIL_VERSION = 2.6.0
PYTHON_DATEUTIL_SITE = https://pypi.python.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6
PYTHON_DATEUTIL_SETUP_TYPE = setuptools
PYTHON_DATEUTIL_LICENSE = BSD-3-Clause
PYTHON_DATEUTIL_LICENSE_FILES = LICENSE

$(eval $(python-package))
