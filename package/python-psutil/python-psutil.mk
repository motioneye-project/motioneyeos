################################################################################
#
# python-psutil
#
################################################################################

PYTHON_PSUTIL_VERSION = 5.4.7
PYTHON_PSUTIL_SOURCE = psutil-$(PYTHON_PSUTIL_VERSION).tar.gz
PYTHON_PSUTIL_SITE = https://files.pythonhosted.org/packages/7d/9a/1e93d41708f8ed2b564395edfa3389f0fd6d567597401c2e5e2775118d8b
PYTHON_PSUTIL_SETUP_TYPE = setuptools
PYTHON_PSUTIL_LICENSE = BSD-3-Clause
PYTHON_PSUTIL_LICENSE_FILES = LICENSE

$(eval $(python-package))
