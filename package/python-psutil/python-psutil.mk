################################################################################
#
# python-psutil
#
################################################################################

PYTHON_PSUTIL_VERSION = 4.2.0
PYTHON_PSUTIL_SOURCE = psutil-$(PYTHON_PSUTIL_VERSION).tar.gz
PYTHON_PSUTIL_SITE = https://pypi.python.org/packages/a6/bf/5ce23dc9f50de662af3b4bf54812438c298634224924c4e18b7c3b57a2aa
PYTHON_PSUTIL_SETUP_TYPE = setuptools
PYTHON_PSUTIL_LICENSE = BSD-3c
PYTHON_PSUTIL_LICENSE_FILES = LICENSE

$(eval $(python-package))
