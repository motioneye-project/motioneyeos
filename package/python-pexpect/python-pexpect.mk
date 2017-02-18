################################################################################
#
# python-pexpect
#
################################################################################

PYTHON_PEXPECT_VERSION = 4.0.1
PYTHON_PEXPECT_SITE = https://pypi.python.org/packages/source/p/pexpect
PYTHON_PEXPECT_SOURCE = pexpect-$(PYTHON_PEXPECT_VERSION).tar.gz
PYTHON_PEXPECT_LICENSE = ISC
PYTHON_PEXPECT_LICENSE_FILES = LICENSE
PYTHON_PEXPECT_SETUP_TYPE = distutils

$(eval $(python-package))
