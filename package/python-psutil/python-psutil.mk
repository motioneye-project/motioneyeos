################################################################################
#
# python-psutil
#
################################################################################

PYTHON_PSUTIL_VERSION = 4.3.0
PYTHON_PSUTIL_SOURCE = psutil-$(PYTHON_PSUTIL_VERSION).tar.gz
PYTHON_PSUTIL_SITE = https://pypi.python.org/packages/22/a8/6ab3f0b3b74a36104785808ec874d24203c6a511ffd2732dd215cf32d689
PYTHON_PSUTIL_SETUP_TYPE = setuptools
PYTHON_PSUTIL_LICENSE = BSD-3c
PYTHON_PSUTIL_LICENSE_FILES = LICENSE

$(eval $(python-package))
