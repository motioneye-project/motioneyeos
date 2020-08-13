################################################################################
#
# python-futures
#
################################################################################

PYTHON_FUTURES_VERSION = 3.3.0
PYTHON_FUTURES_SOURCE = futures-$(PYTHON_FUTURES_VERSION).tar.gz
PYTHON_FUTURES_SITE = https://files.pythonhosted.org/packages/47/04/5fc6c74ad114032cd2c544c575bffc17582295e9cd6a851d6026ab4b2c00
PYTHON_FUTURES_SETUP_TYPE = setuptools
PYTHON_FUTURES_LICENSE = BSD-2-Clause
PYTHON_FUTURES_LICENSE_FILES = LICENSE

$(eval $(python-package))
