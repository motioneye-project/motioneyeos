################################################################################
#
# python-xlutils
#
################################################################################

PYTHON_XLUTILS_VERSION = 2.0.0
PYTHON_XLUTILS_SOURCE = xlutils-$(PYTHON_XLUTILS_VERSION).tar.gz
PYTHON_XLUTILS_SITE = https://pypi.python.org/packages/93/fe/af6d73e4bc7b0ce359d34bebb2e8d4d129763acfecd66a3a7efc587e54c9
PYTHON_XLUTILS_SETUP_TYPE = setuptools
PYTHON_XLUTILS_LICENSE = MIT
PYTHON_XLUTILS_LICENSE_FILES = xlutils/license.txt

$(eval $(python-package))
