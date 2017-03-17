################################################################################
#
# python-pathtools
#
################################################################################

PYTHON_PATHTOOLS_VERSION = 0.1.2
PYTHON_PATHTOOLS_SOURCE = pathtools-$(PYTHON_PATHTOOLS_VERSION).tar.gz
PYTHON_PATHTOOLS_SITE = https://pypi.python.org/packages/e7/7f/470d6fcdf23f9f3518f6b0b76be9df16dcc8630ad409947f8be2eb0ed13a
PYTHON_PATHTOOLS_SETUP_TYPE = setuptools
PYTHON_PATHTOOLS_LICENSE = MIT
PYTHON_PATHTOOLS_LICENSE_FILES = LICENSE

$(eval $(python-package))
