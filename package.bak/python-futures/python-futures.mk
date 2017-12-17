################################################################################
#
# python-futures
#
################################################################################

PYTHON_FUTURES_VERSION = 3.0.5
PYTHON_FUTURES_SOURCE = futures-$(PYTHON_FUTURES_VERSION).tar.gz
PYTHON_FUTURES_SITE = https://pypi.python.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78
PYTHON_FUTURES_SETUP_TYPE = setuptools
PYTHON_FUTURES_LICENSE = BSD-2c
PYTHON_FUTURES_LICENSE_FILES = LICENSE

$(eval $(python-package))
