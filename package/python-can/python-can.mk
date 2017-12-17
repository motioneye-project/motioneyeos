################################################################################
#
# python-can
#
################################################################################

PYTHON_CAN_VERSION = 1.5.2
PYTHON_CAN_SITE = https://pypi.python.org/packages/a1/b1/80f023e2b728c7ebccbf989aec777f3add3dd4cee650573ce5d38132a07c
PYTHON_CAN_LICENSE = LGPL-3.0
PYTHON_CAN_LICENSE_FILES = LICENSE.txt
PYTHON_CAN_SETUP_TYPE = setuptools

$(eval $(python-package))
