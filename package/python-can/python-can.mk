################################################################################
#
# python-can
#
################################################################################

PYTHON_CAN_VERSION = ae5b6cf
PYTHON_CAN_SITE = https://bitbucket.org/hardbyte/python-can/get
PYTHON_CAN_SOURCE = $(PYTHON_CAN_VERSION).tar.bz2
PYTHON_CAN_LICENSE = LGPLv3
PYTHON_CAN_LICENSE_FILES = LICENSE.txt
PYTHON_CAN_SETUP_TYPE = setuptools

$(eval $(python-package))
