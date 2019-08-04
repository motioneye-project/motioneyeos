################################################################################
#
# python-autobahn
#
################################################################################

PYTHON_AUTOBAHN_VERSION = 19.8.1
PYTHON_AUTOBAHN_SOURCE = autobahn-$(PYTHON_AUTOBAHN_VERSION).tar.gz
PYTHON_AUTOBAHN_SITE = https://files.pythonhosted.org/packages/7b/b9/3460d9f73aba656f06a22f2bbc92e1c31e567372d66614651582858c93ae
PYTHON_AUTOBAHN_LICENSE = MIT
PYTHON_AUTOBAHN_LICENSE_FILES = LICENSE
PYTHON_AUTOBAHN_SETUP_TYPE = setuptools

$(eval $(python-package))
