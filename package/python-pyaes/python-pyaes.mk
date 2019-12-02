################################################################################
#
# python-pyaes
#
################################################################################

PYTHON_PYAES_VERSION = 1.6.1
PYTHON_PYAES_SOURCE = pyaes-$(PYTHON_PYAES_VERSION).tar.gz
PYTHON_PYAES_SITE = https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72
PYTHON_PYAES_SETUP_TYPE = distutils
PYTHON_PYAES_LICENSE = MIT
PYTHON_PYAES_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
