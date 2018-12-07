################################################################################
#
# python-aiorwlock
#
################################################################################

PYTHON_AIORWLOCK_VERSION = 0.5.0
PYTHON_AIORWLOCK_SOURCE = aiorwlock-$(PYTHON_AIORWLOCK_VERSION).tar.gz
PYTHON_AIORWLOCK_SITE = https://files.pythonhosted.org/packages/0c/20/d30f332e6ecb2be467ab5603e277b26e3a8eb2a72f75bf8d309bdd4c0c82
PYTHON_AIORWLOCK_SETUP_TYPE = setuptools
PYTHON_AIORWLOCK_LICENSE = Apache-2.0
PYTHON_AIORWLOCK_LICENSE_FILES = LICENSE

$(eval $(python-package))
