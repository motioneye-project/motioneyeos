################################################################################
#
# python3-psutil
#
################################################################################

# Please keep in sync with package/python-psutil/python-psutil.mk
PYTHON3_PSUTIL_VERSION = 5.7.0
PYTHON3_PSUTIL_SOURCE = psutil-$(PYTHON3_PSUTIL_VERSION).tar.gz
PYTHON3_PSUTIL_SITE = https://files.pythonhosted.org/packages/c4/b8/3512f0e93e0db23a71d82485ba256071ebef99b227351f0f5540f744af41
PYTHON3_PSUTIL_SETUP_TYPE = setuptools
PYTHON3_PSUTIL_LICENSE = BSD-3-Clause
PYTHON3_PSUTIL_LICENSE_FILES = LICENSE
HOST_PYTHON3_PSUTIL_DL_SUBDIR = python-psutil
HOST_PYTHON3_PSUTIL_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
