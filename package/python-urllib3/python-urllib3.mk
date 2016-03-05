################################################################################
#
# python-urllib3
#
################################################################################

PYTHON_URLLIB3_VERSION = 1.14
PYTHON_URLLIB3_SOURCE = urllib3-$(PYTHON_URLLIB3_VERSION).tar.gz
PYTHON_URLLIB3_SITE = https://pypi.python.org/packages/source/u/urllib3
PYTHON_URLLIB3_LICENSE = MIT
PYTHON_URLLIB3_LICENSE_FILES = LICENSE.txt
PYTHON_URLLIB3_SETUP_TYPE = setuptools

$(eval $(python-package))
