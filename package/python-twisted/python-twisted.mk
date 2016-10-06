################################################################################
#
# python-twisted
#
################################################################################

PYTHON_TWISTED_VERSION = 16.4.1
PYTHON_TWISTED_SOURCE = Twisted-$(PYTHON_TWISTED_VERSION).tar.bz2
PYTHON_TWISTED_SITE = https://pypi.python.org/packages/6b/23/8dbe86fc83215015e221fbd861a545c6ec5c9e9cd7514af114d1f64084ab
PYTHON_TWISTED_SETUP_TYPE = setuptools
PYTHON_TWISTED_LICENSE = MIT
PYTHON_TWISTED_LICENSE_FILES = LICENSE

$(eval $(python-package))
