################################################################################
#
# python-bottle
#
################################################################################

PYTHON_BOTTLE_VERSION = 0.12.13
PYTHON_BOTTLE_SOURCE = bottle-$(PYTHON_BOTTLE_VERSION).tar.gz
PYTHON_BOTTLE_SITE = https://pypi.python.org/packages/bd/99/04dc59ced52a8261ee0f965a8968717a255ea84a36013e527944dbf3468c
PYTHON_BOTTLE_LICENSE = MIT
# README.rst refers to the file "LICENSE" but it's not included
PYTHON_BOTTLE_SETUP_TYPE = setuptools

$(eval $(python-package))
