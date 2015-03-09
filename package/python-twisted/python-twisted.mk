################################################################################
#
# python-twisted
#
################################################################################

PYTHON_TWISTED_VERSION = 14.0.2
PYTHON_TWISTED_SOURCE = Twisted-$(PYTHON_TWISTED_VERSION).tar.bz2
PYTHON_TWISTED_SITE = https://pypi.python.org/packages/source/T/Twisted
PYTHON_TWISTED_SETUP_TYPE = setuptools
PYTHON_TWISTED_LICENSE = MIT
PYTHON_TWISTED_LICENSE_FILES = LICENSE

$(eval $(python-package))
