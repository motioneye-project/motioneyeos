################################################################################
#
# python-shutilwhich
#
################################################################################

PYTHON_SHUTILWHICH_VERSION = 1.1.0
PYTHON_SHUTILWHICH_SOURCE = shutilwhich-$(PYTHON_SHUTILWHICH_VERSION).tar.gz
PYTHON_SHUTILWHICH_SITE = https://pypi.python.org/packages/source/s/shutilwhich
PYTHON_SHUTILWHICH_LICENSE = Python-2.0
PYTHON_SHUTILWHICH_SETUP_TYPE = setuptools

$(eval $(python-package))
