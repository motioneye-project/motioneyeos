################################################################################
#
# python-twisted
#
################################################################################

PYTHON_TWISTED_VERSION = 19.7.0
PYTHON_TWISTED_SOURCE = Twisted-$(PYTHON_TWISTED_VERSION).tar.bz2
PYTHON_TWISTED_SITE = https://files.pythonhosted.org/packages/61/31/3855dcacd1d3b2e60c0b4ccc8e727b8cd497bd7087d327d81a9f0cbb580c
PYTHON_TWISTED_SETUP_TYPE = setuptools
PYTHON_TWISTED_LICENSE = MIT
PYTHON_TWISTED_LICENSE_FILES = LICENSE
PYTHON_TWISTED_DEPENDENCIES = python-incremental host-python-incremental

$(eval $(python-package))
