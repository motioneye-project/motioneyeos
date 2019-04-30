################################################################################
#
# python-ply
#
################################################################################

PYTHON_PLY_VERSION = 3.11
PYTHON_PLY_SOURCE = ply-$(PYTHON_PLY_VERSION).tar.gz
PYTHON_PLY_SITE = https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da
PYTHON_PLY_SETUP_TYPE = setuptools
PYTHON_PLY_LICENSE = BSD-3-Clause
PYTHON_PLY_LICENSE_FILES = README.md

$(eval $(python-package))
$(eval $(host-python-package))
