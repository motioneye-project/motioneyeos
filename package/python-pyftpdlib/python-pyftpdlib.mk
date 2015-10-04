################################################################################
#
# python-pyftpdlib
#
################################################################################

PYTHON_PYFTPDLIB_VERSION = 1.4.0
PYTHON_PYFTPDLIB_SITE = $(call github,giampaolo,pyftpdlib,release-$(PYTHON_PYFTPDLIB_VERSION))
PYTHON_PYFTPDLIB_SETUP_TYPE = setuptools
PYTHON_PYFTPDLIB_LICENSE = MIT
PYTHON_PYFTPDLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
