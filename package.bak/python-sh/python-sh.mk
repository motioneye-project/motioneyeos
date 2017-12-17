################################################################################
#
# python-sh
#
################################################################################

PYTHON_SH_VERSION = 1.12.7
PYTHON_SH_SOURCE = sh-$(PYTHON_SH_VERSION).tar.gz
PYTHON_SH_SITE = https://pypi.python.org/packages/c2/98/565d9b566b3153607336ae9e91c1c467896f7f786c2d5d8e50fef7d75b08
PYTHON_SH_SETUP_TYPE = setuptools
PYTHON_SH_LICENSE = MIT
PYTHON_SH_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
