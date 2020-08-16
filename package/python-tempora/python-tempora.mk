################################################################################
#
# python-tempora
#
################################################################################

PYTHON_TEMPORA_VERSION = 1.14.1
PYTHON_TEMPORA_SOURCE = tempora-$(PYTHON_TEMPORA_VERSION).tar.gz
PYTHON_TEMPORA_SITE = https://files.pythonhosted.org/packages/2f/b5/5b0464385454c5ca93a39a1c6acefdf574aeb10ef45fa8958b3832cc7d96
PYTHON_TEMPORA_LICENSE = MIT
PYTHON_TEMPORA_LICENSE_FILES = LICENSE
PYTHON_TEMPORA_SETUP_TYPE = setuptools
PYTHON_TEMPORA_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
