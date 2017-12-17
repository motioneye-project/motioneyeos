################################################################################
#
# python-crc16
#
################################################################################

PYTHON_CRC16_VERSION = 0.1.1
PYTHON_CRC16_SITE = $(call github,gennady,pycrc16,v$(PYTHON_CRC16_VERSION))
PYTHON_CRC16_LICENSE = LGPL-3.0+
PYTHON_CRC16_LICENSE_FILES = COPYING.txt
PYTHON_CRC16_SETUP_TYPE = distutils

$(eval $(python-package))
