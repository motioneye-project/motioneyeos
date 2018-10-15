################################################################################
#
# python-twisted
#
################################################################################

PYTHON_TWISTED_VERSION = 18.9.0
PYTHON_TWISTED_SOURCE = Twisted-$(PYTHON_TWISTED_VERSION).tar.bz2
PYTHON_TWISTED_SITE = https://files.pythonhosted.org/packages/5d/0e/a72d85a55761c2c3ff1cb968143a2fd5f360220779ed90e0fadf4106d4f2
PYTHON_TWISTED_SETUP_TYPE = setuptools
PYTHON_TWISTED_LICENSE = MIT
PYTHON_TWISTED_LICENSE_FILES = LICENSE
PYTHON_TWISTED_DEPENDENCIES = python-incremental host-python-incremental

$(eval $(python-package))
