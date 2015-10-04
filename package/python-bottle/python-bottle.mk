################################################################################
#
# python-bottle
#
################################################################################

PYTHON_BOTTLE_VERSION = 0.12.7
PYTHON_BOTTLE_SOURCE = bottle-$(PYTHON_BOTTLE_VERSION).tar.gz
PYTHON_BOTTLE_SITE = http://pypi.python.org/packages/source/b/bottle
PYTHON_BOTTLE_LICENSE = MIT
# README.rst refers to the file "LICENSE" but it's not included
PYTHON_BOTTLE_SETUP_TYPE = distutils

$(eval $(python-package))
