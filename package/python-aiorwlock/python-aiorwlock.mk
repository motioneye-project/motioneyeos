################################################################################
#
# python-aiorwlock
#
################################################################################

PYTHON_AIORWLOCK_VERSION = 0.6.0
PYTHON_AIORWLOCK_SOURCE = aiorwlock-$(PYTHON_AIORWLOCK_VERSION).tar.gz
PYTHON_AIORWLOCK_SITE = https://files.pythonhosted.org/packages/77/cf/2a2584c4fc1096ae959d7d189f205eb9c872ec58aca2cde16009d2d83b9e
PYTHON_AIORWLOCK_SETUP_TYPE = setuptools
PYTHON_AIORWLOCK_LICENSE = Apache-2.0
PYTHON_AIORWLOCK_LICENSE_FILES = LICENSE

$(eval $(python-package))
