################################################################################
#
# python-shutilwhich
#
################################################################################

PYTHON_SHUTILWHICH_VERSION = 1.1.0
PYTHON_SHUTILWHICH_SOURCE = shutilwhich-$(PYTHON_SHUTILWHICH_VERSION).tar.gz
PYTHON_SHUTILWHICH_SITE = http://pypi.python.org/packages/source/s/shutilwhich
PYTHON_SHUTILWHICH_LICENSE = Python Software Foundation License
PYTHON_SHUTILWHICH_SETUP_TYPE = setuptools

$(eval $(python-package))
