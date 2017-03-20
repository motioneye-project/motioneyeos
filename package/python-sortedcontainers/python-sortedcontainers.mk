################################################################################
#
# python-sortedcontainers
#
################################################################################

PYTHON_SORTEDCONTAINERS_VERSION = 1.5.7
PYTHON_SORTEDCONTAINERS_SOURCE = sortedcontainers-$(PYTHON_SORTEDCONTAINERS_VERSION).tar.gz
PYTHON_SORTEDCONTAINERS_SITE = https://pypi.python.org/packages/8d/aa/5369362d730728639ba434318df26b5c554804578d1c48381367ea5377c6
PYTHON_SORTEDCONTAINERS_SETUP_TYPE = setuptools
PYTHON_SORTEDCONTAINERS_LICENSE = Apache-2.0
PYTHON_SORTEDCONTAINERS_LICENSE_FILES = LICENSE

$(eval $(python-package))
