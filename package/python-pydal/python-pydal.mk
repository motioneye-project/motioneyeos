################################################################################
#
# python-pydal
#
################################################################################

PYTHON_PYDAL_VERSION = 16.9
PYTHON_PYDAL_SOURCE = pyDAL-$(PYTHON_PYDAL_VERSION).tar.gz
PYTHON_PYDAL_SITE = https://pypi.python.org/packages/31/cb/7537f8d848106e3e4b4063955395a5dc3177c32c2cd2cc0a1938a486d4fa
PYTHON_PYDAL_LICENSE = BSD-3c
PYTHON_PYDAL_LICENSE_FILES = LICENSE
PYTHON_PYDAL_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
