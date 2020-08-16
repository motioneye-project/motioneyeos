################################################################################
#
# python-webencodings
#
################################################################################

PYTHON_WEBENCODINGS_VERSION = 0.5.1
PYTHON_WEBENCODINGS_SOURCE = webencodings-$(PYTHON_WEBENCODINGS_VERSION).tar.gz
PYTHON_WEBENCODINGS_SITE = https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47
PYTHON_WEBENCODINGS_SETUP_TYPE = setuptools
PYTHON_WEBENCODINGS_LICENSE = BSD-3-Clause
PYTHON_WEBENCODINGS_LICENSE_FILES = PKG-INFO

$(eval $(python-package))
