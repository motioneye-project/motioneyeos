################################################################################
#
# python-engineio
#
################################################################################

PYTHON_ENGINEIO_VERSION = 3.9.3
PYTHON_ENGINEIO_SITE = https://files.pythonhosted.org/packages/f4/e4/d46daeb6010781d56f3468d0ad4e11e2d44aafc4ec521327a19d80f536f2
PYTHON_ENGINEIO_SETUP_TYPE = setuptools
PYTHON_ENGINEIO_LICENSE = MIT
PYTHON_ENGINEIO_LICENSE_FILES = LICENSE

$(eval $(python-package))
