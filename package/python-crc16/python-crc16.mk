################################################################################
#
# python-crc16
#
################################################################################

PYTHON_CRC16_VERSION = 0.1.1
PYTHON_CRC16_SOURCE = crc16-$(PYTHON_CRC16_VERSION).tar.gz
PYTHON_CRC16_SITE = http://pycrc16.googlecode.com/files/
PYTHON_CRC16_LICENSE = LGPLv3+
PYTHON_CRC16_LICENSE_FILES = COPYING.txt
PYTHON_CRC16_SETUP_TYPE = distutils

$(eval $(python-package))
