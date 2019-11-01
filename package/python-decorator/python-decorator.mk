################################################################################
#
# python-decorator
#
################################################################################

PYTHON_DECORATOR_VERSION = 4.4.1
PYTHON_DECORATOR_SITE = https://files.pythonhosted.org/packages/dc/c3/9d378af09f5737cfd524b844cd2fbb0d2263a35c11d712043daab290144d
PYTHON_DECORATOR_SOURCE = decorator-$(PYTHON_DECORATOR_VERSION).tar.gz
PYTHON_DECORATOR_LICENSE = BSD-2-Clause
PYTHON_DECORATOR_LICENSE_FILES = LICENSE.txt
PYTHON_DECORATOR_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
