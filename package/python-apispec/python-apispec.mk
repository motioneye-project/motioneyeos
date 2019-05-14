################################################################################
#
# python-apispec
#
################################################################################

PYTHON_APISPEC_VERSION = 1.3.3
PYTHON_APISPEC_SOURCE = apispec-$(PYTHON_APISPEC_VERSION).tar.gz
PYTHON_APISPEC_SITE = https://files.pythonhosted.org/packages/99/9e/c2af08f8ddbfbba13d48d26db58b905734bfc1f42d38471551769aa59726
PYTHON_APISPEC_SETUP_TYPE = setuptools
PYTHON_APISPEC_LICENSE = Apache-2.0
PYTHON_APISPEC_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
