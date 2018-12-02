################################################################################
#
# python-pycares
#
################################################################################

PYTHON_PYCARES_VERSION = 2.3.0
PYTHON_PYCARES_SOURCE = pycares-$(PYTHON_PYCARES_VERSION).tar.gz
PYTHON_PYCARES_SITE = https://files.pythonhosted.org/packages/89/5c/3a7e1a52d6abb52b9ca1a56d2df699936e89d8b98f75cfd60d03363e7c10
PYTHON_PYCARES_SETUP_TYPE = setuptools
PYTHON_PYCARES_LICENSE = MIT
PYTHON_PYCARES_LICENSE_FILES = LICENSE

$(eval $(python-package))
