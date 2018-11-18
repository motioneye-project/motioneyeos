################################################################################
#
# python-pytablereader
#
################################################################################

PYTHON_PYTABLEREADER_VERSION = 0.15.0
PYTHON_PYTABLEREADER_SOURCE = pytablereader-$(PYTHON_PYTABLEREADER_VERSION).tar.gz
PYTHON_PYTABLEREADER_SITE = https://pypi.python.org/packages/34/53/e2f51f2efe42c4045ad0822d4ffe739788a74cca35ba7d0bc59a53ec9424
PYTHON_PYTABLEREADER_SETUP_TYPE = setuptools
PYTHON_PYTABLEREADER_LICENSE = MIT
PYTHON_PYTABLEREADER_LICENSE_FILES = LICENSE

$(eval $(python-package))
