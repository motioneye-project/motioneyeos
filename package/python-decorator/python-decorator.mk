################################################################################
#
# python-decorator
#
################################################################################

PYTHON_DECORATOR_VERSION = 4.4.0
PYTHON_DECORATOR_SITE = https://files.pythonhosted.org/packages/ba/19/1119fe7b1e49b9c8a9f154c930060f37074ea2e8f9f6558efc2eeaa417a2
PYTHON_DECORATOR_SOURCE = decorator-$(PYTHON_DECORATOR_VERSION).tar.gz
PYTHON_DECORATOR_LICENSE = BSD-2-Clause
PYTHON_DECORATOR_LICENSE_FILES = LICENSE.txt
PYTHON_DECORATOR_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
