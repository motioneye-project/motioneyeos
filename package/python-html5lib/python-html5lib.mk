################################################################################
#
# python-html5lib
#
################################################################################

PYTHON_HTML5LIB_VERSION = 1.0.1
PYTHON_HTML5LIB_SOURCE = html5lib-$(PYTHON_HTML5LIB_VERSION).tar.gz
PYTHON_HTML5LIB_SITE = https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f
PYTHON_HTML5LIB_LICENSE = MIT
PYTHON_HTML5LIB_LICENSE_FILES = LICENSE
PYTHON_HTML5LIB_SETUP_TYPE = setuptools

$(eval $(python-package))
