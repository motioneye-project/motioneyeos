################################################################################
#
# python-picamera
#
################################################################################

PYTHON_PICAMERA_VERSION = 1.12
PYTHON_PICAMERA_SOURCE = picamera-$(PYTHON_PICAMERA_VERSION).tar.gz
PYTHON_PICAMERA_SITE = https://pypi.python.org/packages/ab/53/54a20f53e61df5c329480207fb0b6e6e25c64d16e82e899de335e08df7d9
PYTHON_PICAMERA_SETUP_TYPE = distutils

$(eval $(python-package))
