################################################################################
#
# python-twisted
#
################################################################################

PYTHON_TWISTED_VERSION = 19.2.1
PYTHON_TWISTED_SOURCE = Twisted-$(PYTHON_TWISTED_VERSION).tar.bz2
PYTHON_TWISTED_SITE = https://files.pythonhosted.org/packages/79/59/035de19362320e632301ed7bbde23e4c8cd6fc5e2f1cf8d354cdba857854
PYTHON_TWISTED_SETUP_TYPE = setuptools
PYTHON_TWISTED_LICENSE = MIT
PYTHON_TWISTED_LICENSE_FILES = LICENSE
PYTHON_TWISTED_DEPENDENCIES = python-incremental host-python-incremental

$(eval $(python-package))
