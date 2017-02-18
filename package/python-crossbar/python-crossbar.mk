################################################################################
#
# python-crossbar
#
################################################################################

PYTHON_CROSSBAR_VERSION = 0.12.1
PYTHON_CROSSBAR_SOURCE = crossbar-$(PYTHON_CROSSBAR_VERSION).tar.gz
PYTHON_CROSSBAR_SITE = http://pypi.python.org/packages/source/c/crossbar
PYTHON_CROSSBAR_LICENSE = AGPLv3
PYTHON_CROSSBAR_LICENSE_FILES = LICENSE
PYTHON_CROSSBAR_SETUP_TYPE = setuptools

$(eval $(python-package))
