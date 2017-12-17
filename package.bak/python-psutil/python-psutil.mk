################################################################################
#
# python-psutil
#
################################################################################

PYTHON_PSUTIL_VERSION = 4.3.1
PYTHON_PSUTIL_SOURCE = psutil-$(PYTHON_PSUTIL_VERSION).tar.gz
PYTHON_PSUTIL_SITE = https://pypi.python.org/packages/78/cc/f267a1371f229bf16db6a4e604428c3b032b823b83155bd33cef45e49a53
PYTHON_PSUTIL_SETUP_TYPE = setuptools
PYTHON_PSUTIL_LICENSE = BSD-3c
PYTHON_PSUTIL_LICENSE_FILES = LICENSE

$(eval $(python-package))
