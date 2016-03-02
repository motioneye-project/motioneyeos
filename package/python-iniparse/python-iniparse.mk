################################################################################
#
# python-iniparse
#
################################################################################

PYTHON_INIPARSE_VERSION = 0.4
PYTHON_INIPARSE_SOURCE = iniparse-$(PYTHON_INIPARSE_VERSION).tar.gz
PYTHON_INIPARSE_SITE = https://pypi.python.org/packages/source/i/iniparse
PYTHON_INIPARSE_LICENSE = Python software foundation license v2, MIT
PYTHON_INIPARSE_LICENSE_FILES = LICENSE-PSF LICENSE
PYTHON_INIPARSE_SETUP_TYPE = distutils

$(eval $(python-package))
