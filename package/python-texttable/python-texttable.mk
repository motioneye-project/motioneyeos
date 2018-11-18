################################################################################
#
# python-texttable
#
################################################################################

PYTHON_TEXTTABLE_VERSION = 0.9.1
PYTHON_TEXTTABLE_SOURCE = texttable-$(PYTHON_TEXTTABLE_VERSION).tar.gz
PYTHON_TEXTTABLE_SITE = https://pypi.python.org/packages/02/e1/2565e6b842de7945af0555167d33acfc8a615584ef7abd30d1eae00a4d80
PYTHON_TEXTTABLE_SETUP_TYPE = distutils
PYTHON_TEXTTABLE_LICENSE = LGPL-3.0+
PYTHON_TEXTTABLE_LICENSE_FILES = LICENSE

$(eval $(python-package))
