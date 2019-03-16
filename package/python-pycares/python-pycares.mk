################################################################################
#
# python-pycares
#
################################################################################

PYTHON_PYCARES_VERSION = 3.0.0
PYTHON_PYCARES_SOURCE = pycares-$(PYTHON_PYCARES_VERSION).tar.gz
PYTHON_PYCARES_SITE = https://files.pythonhosted.org/packages/85/de/cd46a73e43e206a6ad1e9cf9cc893c3ed1b21caf57f1e0a8d9a119d290eb
PYTHON_PYCARES_SETUP_TYPE = setuptools
PYTHON_PYCARES_LICENSE = MIT
PYTHON_PYCARES_LICENSE_FILES = LICENSE
PYTHON_PYCARES_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
