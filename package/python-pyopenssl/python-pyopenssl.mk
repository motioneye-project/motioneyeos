################################################################################
#
# python-pyopenssl
#
################################################################################

PYTHON_PYOPENSSL_VERSION = 19.0.0
PYTHON_PYOPENSSL_SOURCE = pyOpenSSL-$(PYTHON_PYOPENSSL_VERSION).tar.gz
PYTHON_PYOPENSSL_SITE = https://files.pythonhosted.org/packages/40/d0/8efd61531f338a89b4efa48fcf1972d870d2b67a7aea9dcf70783c8464dc
PYTHON_PYOPENSSL_LICENSE = Apache-2.0
PYTHON_PYOPENSSL_LICENSE_FILES = LICENSE
PYTHON_PYOPENSSL_SETUP_TYPE = setuptools

$(eval $(python-package))
