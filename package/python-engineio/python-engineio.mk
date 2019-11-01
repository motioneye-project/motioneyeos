################################################################################
#
# python-engineio
#
################################################################################

PYTHON_ENGINEIO_VERSION = 3.10.0
PYTHON_ENGINEIO_SITE = https://files.pythonhosted.org/packages/78/8e/c58cf2725fd17d65b9fe818b70aff4ccce4903b47aaee6f4321727a8b8bb
PYTHON_ENGINEIO_SETUP_TYPE = setuptools
PYTHON_ENGINEIO_LICENSE = MIT
PYTHON_ENGINEIO_LICENSE_FILES = LICENSE

$(eval $(python-package))
