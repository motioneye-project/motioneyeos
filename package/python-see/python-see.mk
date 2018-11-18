################################################################################
#
# python-see
#
################################################################################

PYTHON_SEE_VERSION = 1.4.1
PYTHON_SEE_SOURCE = see-$(PYTHON_SEE_VERSION).tar.gz
PYTHON_SEE_SITE = https://pypi.python.org/packages/ff/fc/fcabb6a9bfe7c56798285839780cae67342256b823b97e94d862b0ba21d6
PYTHON_SEE_SETUP_TYPE = setuptools
PYTHON_SEE_LICENSE = BSD-3-Clause
PYTHON_SEE_LICENSE_FILES = LICENSE

$(eval $(python-package))
