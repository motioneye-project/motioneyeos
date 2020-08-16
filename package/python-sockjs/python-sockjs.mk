################################################################################
#
# python-sockjs
#
################################################################################

PYTHON_SOCKJS_VERSION = 0.10.0
PYTHON_SOCKJS_SOURCE = sockjs-$(PYTHON_SOCKJS_VERSION).tar.gz
PYTHON_SOCKJS_SITE = https://files.pythonhosted.org/packages/35/0e/6aa4f3283b064b04a0c7f3859c8c2c0b736c05cfb07853b6d94073c1bf63
PYTHON_SOCKJS_SETUP_TYPE = setuptools
PYTHON_SOCKJS_LICENSE = Apache-2.0
PYTHON_SOCKJS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
