################################################################################
#
# python-scandir
#
################################################################################

PYTHON_SCANDIR_VERSION = 1.5
PYTHON_SCANDIR_SOURCE = scandir-$(PYTHON_SCANDIR_VERSION).tar.gz
PYTHON_SCANDIR_SITE = https://pypi.python.org/packages/bd/f4/3143e0289faf0883228017dbc6387a66d0b468df646645e29e1eb89ea10e
PYTHON_SCANDIR_LICENSE = BSD-3-Clause
PYTHON_SCANDIR_LICENSE_FILE = LICENSE.txt
PYTHON_SCANDIR_SETUP_TYPE = setuptools

$(eval $(python-package))
