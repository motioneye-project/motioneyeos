################################################################################
#
# python-psutil
#
################################################################################

PYTHON_PSUTIL_VERSION = 3.4.2
PYTHON_PSUTIL_SOURCE = psutil-$(PYTHON_PSUTIL_VERSION).tar.gz
PYTHON_PSUTIL_SITE = http://pypi.python.org/packages/source/p/psutil
PYTHON_PSUTIL_SETUP_TYPE = setuptools
PYTHON_PSUTIL_LICENSE = BSD-3c
PYTHON_PSUTIL_LICENSE_FILES = LICENSE

$(eval $(python-package))
