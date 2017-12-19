################################################################################
#
# python-sh
#
################################################################################

PYTHON_SH_VERSION = 1.12.14
PYTHON_SH_SOURCE = sh-$(PYTHON_SH_VERSION).tar.gz
PYTHON_SH_SITE = https://pypi.python.org/packages/7c/71/199d27d3e7e78bf448bcecae0105a1d5b29173ffd2bbadaa95a74c156770
PYTHON_SH_SETUP_TYPE = setuptools
PYTHON_SH_LICENSE = MIT
PYTHON_SH_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
