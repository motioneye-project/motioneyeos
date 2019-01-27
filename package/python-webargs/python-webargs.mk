################################################################################
#
# python-webargs
#
################################################################################

PYTHON_WEBARGS_VERSION = 4.2.0
PYTHON_WEBARGS_SOURCE = webargs-$(PYTHON_WEBARGS_VERSION).tar.gz
PYTHON_WEBARGS_SITE = https://files.pythonhosted.org/packages/ce/55/23c0b271813793cce879908fdc319c79500d9adb0e4982f0d9fce2da2846
PYTHON_WEBARGS_SETUP_TYPE = setuptools
PYTHON_WEBARGS_LICENSE = Apache-2.0
PYTHON_WEBARGS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
