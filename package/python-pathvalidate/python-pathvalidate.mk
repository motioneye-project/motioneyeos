################################################################################
#
# python-pathvalidate
#
################################################################################

PYTHON_PATHVALIDATE_VERSION = 0.13.0
PYTHON_PATHVALIDATE_SOURCE = pathvalidate-$(PYTHON_PATHVALIDATE_VERSION).tar.gz
PYTHON_PATHVALIDATE_SITE = https://pypi.python.org/packages/3a/03/ca01cdbf0f7b766b414d134e71b2eb689619dba0ddee002d53c2d58f6436
PYTHON_PATHVALIDATE_SETUP_TYPE = setuptools
PYTHON_PATHVALIDATE_LICENSE = MIT
PYTHON_PATHVALIDATE_LICENSE_FILES = LICENSE

$(eval $(python-package))
