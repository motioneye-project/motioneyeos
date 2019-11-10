################################################################################
#
# python-future
#
################################################################################

PYTHON_FUTURE_VERSION = 0.18.2
PYTHON_FUTURE_SOURCE = future-$(PYTHON_FUTURE_VERSION).tar.gz
PYTHON_FUTURE_SITE = https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9
PYTHON_FUTURE_SETUP_TYPE = setuptools
PYTHON_FUTURE_LICENSE = MIT
PYTHON_FUTURE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
