################################################################################
#
# python-bottle
#
################################################################################

PYTHON_BOTTLE_VERSION = 0.12.11
PYTHON_BOTTLE_SOURCE = bottle-$(PYTHON_BOTTLE_VERSION).tar.gz
PYTHON_BOTTLE_SITE = https://pypi.python.org/packages/a1/f6/0db23aeeb40c9a7c5d226b1f70ce63822c567178eee5b623bca3e0cc3bef
PYTHON_BOTTLE_LICENSE = MIT
# README.rst refers to the file "LICENSE" but it's not included
PYTHON_BOTTLE_SETUP_TYPE = setuptools

$(eval $(python-package))
